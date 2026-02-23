#!/bin/bash
# PostToolUse(Write) Hook: 에세이 파일 저장 시 단어수 자동 체크
# stdin으로 JSON 형식의 tool_use 정보를 받습니다

# tool_input에서 file_path 추출
FILE_PATH=$(jq -r '.tool_input.file_path // empty' 2>/dev/null)

# 에세이 디렉토리의 .md 파일이 아니면 종료
if [ -z "$FILE_PATH" ]; then
  exit 0
fi

if [[ "$FILE_PATH" != essays/* ]] || [[ "$FILE_PATH" != *.md ]]; then
  exit 0
fi

# 파일이 존재하지 않으면 종료
if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

# YAML frontmatter에서 word_limit 추출
WORD_LIMIT=$(grep -m1 "^word_limit:" "$FILE_PATH" 2>/dev/null | awk '{print $2}')

# frontmatter 제외한 본문 단어수 계산
# ---로 시작하는 frontmatter 블록 제거 후 카운트
CONTENT=$(awk '/^---/{if(++c==2){found=1; next}} found' "$FILE_PATH" 2>/dev/null)
WORD_COUNT=$(echo "$CONTENT" | wc -w | tr -d ' ')

# 결과 출력
echo ""
echo "📝 에세이 단어수 체크: $(basename "$FILE_PATH")"
echo "   현재: ${WORD_COUNT}단어"

if [ -n "$WORD_LIMIT" ] && [ "$WORD_LIMIT" -gt 0 ]; then
  PERCENT=$(( WORD_COUNT * 100 / WORD_LIMIT ))
  echo "   제한: ${WORD_LIMIT}단어 (${PERCENT}%)"

  if [ "$WORD_COUNT" -gt "$WORD_LIMIT" ]; then
    OVER=$(( WORD_COUNT - WORD_LIMIT ))
    echo "   ⚠️  제한 초과: ${OVER}단어 줄여야 합니다!"
  elif [ "$PERCENT" -ge 90 ]; then
    echo "   ✅ 양호 (90%+ 달성)"
  elif [ "$PERCENT" -ge 75 ]; then
    echo "   🟡 조금 더 작성 필요 (${PERCENT}%)"
  else
    echo "   🔴 더 작성 필요 (${PERCENT}%)"
  fi
else
  echo "   (word_limit 미설정 — frontmatter에 word_limit: 650 추가 권장)"
fi

echo ""
exit 0
