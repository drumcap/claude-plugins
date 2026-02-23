#!/bin/bash
# TeammateIdle Hook: teammate가 idle 상태가 되기 전 결과물 품질 검증
# exit 2 반환 시 → teammate를 계속 실행시키고 피드백 메시지 전달
# exit 0 반환 시 → idle 허용

# stdin에서 JSON 파싱 (teammate 정보)
INPUT=$(cat)
TEAMMATE_NAME=$(echo "$INPUT" | jq -r '.teammate_name // empty' 2>/dev/null)
AGENT_TYPE=$(echo "$INPUT" | jq -r '.agent_type // empty' 2>/dev/null)

# research-agent teammate 검증
if [[ "$AGENT_TYPE" == "research-agent" ]] || [[ "$TEAMMATE_NAME" == *"research"* ]]; then
  # 최근 저장된 research 파일 확인
  LATEST_RESEARCH=$(find research -name "*.md" -newer _data/transfer.tsv 2>/dev/null | head -1)

  if [ -z "$LATEST_RESEARCH" ]; then
    echo "검증 실패: research/ 파일이 생성되지 않았습니다. 리서치를 완료하고 파일을 저장하세요."
    exit 2
  fi

  # 품질 기준: 교수명 또는 랩명이 2개 이상 포함되어야 함
  # "Professor", "Lab", "Dr.", "Prof." 등의 키워드 카운트
  SPECIFIC_COUNT=$(grep -iE "(professor|lab|dr\.|prof\.|research group|center for)" "$LATEST_RESEARCH" 2>/dev/null | wc -l | tr -d ' ')

  if [ "$SPECIFIC_COUNT" -lt 2 ]; then
    echo "검증 실패: ${LATEST_RESEARCH}에 구체적인 교수명/랩명이 부족합니다 (현재 ${SPECIFIC_COUNT}개, 최소 2개 필요)."
    echo "에세이에 즉시 활용 가능한 교수명, 랩명, 또는 특정 과목명을 추가하세요."
    exit 2
  fi
fi

# essay-writer teammate 검증
if [[ "$AGENT_TYPE" == "essay-writer" ]] || [[ "$TEAMMATE_NAME" == *"writer"* ]]; then
  # 최근 저장된 에세이 파일 확인
  LATEST_ESSAY=$(find essays -name "*.md" -newer _data/transfer.tsv 2>/dev/null | head -1)

  if [ -z "$LATEST_ESSAY" ]; then
    echo "검증 실패: essays/ 에 새로 작성된 파일이 없습니다. 에세이를 작성하고 저장하세요."
    exit 2
  fi

  # YAML frontmatter 완성 여부 확인
  HAS_FRONTMATTER=$(head -20 "$LATEST_ESSAY" 2>/dev/null | grep -c "^word_count:")
  if [ "$HAS_FRONTMATTER" -eq 0 ]; then
    echo "검증 실패: ${LATEST_ESSAY}의 YAML frontmatter가 불완전합니다. word_count 필드를 추가하세요."
    exit 2
  fi
fi

# essay-reviewer teammate 검증
if [[ "$AGENT_TYPE" == "essay-reviewer" ]] || [[ "$TEAMMATE_NAME" == *"reviewer"* ]]; then
  # 리뷰 결과에 점수가 포함되어 있는지 확인 (출력 내용 검증은 어려우므로 기본 pass)
  # 실제 구현에서는 리뷰 결과 파일을 저장하도록 확장 가능
  :
fi

exit 0
