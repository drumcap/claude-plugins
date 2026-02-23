#!/bin/bash
# SessionStart Hook: 마감일 임박 시 경고 메시지 출력
# Claude Code 세션 시작 시 자동 실행됩니다

TSV_FILE="_data/transfer.tsv"

# TSV 파일이 없으면 조용히 종료
if [ ! -f "$TSV_FILE" ]; then
  exit 0
fi

TODAY=$(date '+%Y-%m-%d')
TODAY_TS=$(date -j -f "%Y-%m-%d" "$TODAY" "+%s" 2>/dev/null || date -d "$TODAY" "+%s" 2>/dev/null)

URGENT=""
WARNING=""

# TSV 파싱 (헤더 제외)
while IFS=$'\t' read -r school short deadline doc_deadline rest; do
  [ "$school" = "School" ] && continue
  [ -z "$deadline" ] && continue

  # 날짜를 타임스탬프로 변환 (macOS / Linux 호환)
  DEADLINE_TS=$(date -j -f "%Y-%m-%d" "$deadline" "+%s" 2>/dev/null || date -d "$deadline" "+%s" 2>/dev/null)
  [ -z "$DEADLINE_TS" ] && continue

  DIFF_DAYS=$(( (DEADLINE_TS - TODAY_TS) / 86400 ))

  if [ "$DIFF_DAYS" -lt 0 ]; then
    continue  # 마감 지남, 무시
  elif [ "$DIFF_DAYS" -le 3 ]; then
    URGENT="${URGENT}  🔴 ${school} — D-${DIFF_DAYS} (${deadline})\n"
  elif [ "$DIFF_DAYS" -le 7 ]; then
    WARNING="${WARNING}  🟡 ${school} — D-${DIFF_DAYS} (${deadline})\n"
  fi
done < "$TSV_FILE"

# 출력 (무언가 있을 때만)
if [ -n "$URGENT" ] || [ -n "$WARNING" ]; then
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "📅 편입 마감일 알림 (오늘: $TODAY)"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  if [ -n "$URGENT" ]; then
    echo "🚨 긴급 (D-3 이내):"
    printf "$URGENT"
  fi
  if [ -n "$WARNING" ]; then
    echo "⚠️  임박 (D-7 이내):"
    printf "$WARNING"
  fi
  echo ""
  echo "→ /college-transfer:checklist 로 오늘 할 일을 확인하세요"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
fi

exit 0
