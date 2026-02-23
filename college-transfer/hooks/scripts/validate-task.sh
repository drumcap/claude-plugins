#!/bin/bash
# TaskCompleted Hook: 태스크 완료 전 결과물 검증
# exit 2 반환 시 → 태스크 완료를 막고 피드백 전달
# exit 0 반환 시 → 완료 허용

# stdin에서 JSON 파싱
INPUT=$(cat)
TASK_SUBJECT=$(echo "$INPUT" | jq -r '.task.subject // empty' 2>/dev/null)
TASK_DESC=$(echo "$INPUT" | jq -r '.task.description // empty' 2>/dev/null)

# 리서치 태스크 검증
if echo "$TASK_SUBJECT $TASK_DESC" | grep -qi "research\|리서치"; then
  # 태스크 설명에서 학교 슬러그 추출 시도
  SCHOOL_SLUG=$(echo "$TASK_DESC" | grep -oE "research/[a-z-]+" | head -1 | sed 's|research/||')

  if [ -n "$SCHOOL_SLUG" ]; then
    RESEARCH_FILE="research/${SCHOOL_SLUG}.md"
    if [ ! -f "$RESEARCH_FILE" ]; then
      echo "태스크 완료 거부: ${RESEARCH_FILE} 파일이 존재하지 않습니다."
      echo "리서치 결과를 파일로 저장한 후 완료 처리하세요."
      exit 2
    fi

    # 파일 크기 확인 (너무 짧으면 부실한 리서치)
    FILE_SIZE=$(wc -c < "$RESEARCH_FILE" 2>/dev/null | tr -d ' ')
    if [ "$FILE_SIZE" -lt 500 ]; then
      echo "태스크 완료 거부: ${RESEARCH_FILE}의 내용이 너무 짧습니다 (${FILE_SIZE}자)."
      echo "더 상세한 리서치 내용을 추가하세요 (최소 500자)."
      exit 2
    fi
  fi
fi

# 에세이 작성 태스크 검증
if echo "$TASK_SUBJECT $TASK_DESC" | grep -qi "essay\|에세이\|write"; then
  SCHOOL_SLUG=$(echo "$TASK_DESC" | grep -oE "essays/[a-z-]+" | head -1 | sed 's|essays/||')

  if [ -n "$SCHOOL_SLUG" ]; then
    ESSAY_DIR="essays/${SCHOOL_SLUG}"
    ESSAY_COUNT=$(find "$ESSAY_DIR" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')

    if [ "$ESSAY_COUNT" -eq 0 ]; then
      echo "태스크 완료 거부: ${ESSAY_DIR}/ 에 에세이 파일이 없습니다."
      echo "에세이를 작성하고 저장한 후 완료 처리하세요."
      exit 2
    fi

    # 각 에세이의 단어수 기준 확인
    FAILED=""
    for f in "$ESSAY_DIR"/*.md; do
      [ -f "$f" ] || continue
      WORD_LIMIT=$(grep -m1 "^word_limit:" "$f" 2>/dev/null | awk '{print $2}')
      WORD_COUNT=$(grep -m1 "^word_count:" "$f" 2>/dev/null | awk '{print $2}')

      if [ -n "$WORD_LIMIT" ] && [ -n "$WORD_COUNT" ] && [ "$WORD_LIMIT" -gt 0 ]; then
        PERCENT=$(( WORD_COUNT * 100 / WORD_LIMIT ))
        if [ "$PERCENT" -lt 70 ]; then
          FAILED="${FAILED}\n  - $(basename $f): ${WORD_COUNT}/${WORD_LIMIT}단어 (${PERCENT}%)"
        fi
      fi
    done

    if [ -n "$FAILED" ]; then
      echo "태스크 완료 거부: 단어수 부족한 에세이가 있습니다 (기준: 70% 이상):"
      printf "$FAILED\n"
      echo "에세이 내용을 보완한 후 완료 처리하세요."
      exit 2
    fi
  fi
fi

exit 0
