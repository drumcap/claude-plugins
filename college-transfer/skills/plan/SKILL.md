---
name: plan
description: deadline-planner 에이전트가 마감일, 에세이 현황, 서류 상태를 분석해 최적화된 주간 액션플랜을 수립한다.
disable-model-invocation: true
context: fork
agent: deadline-planner
allowed-tools: Read, Glob
---

# /college-transfer:plan - 최적 액션플랜 수립

## 사전 수집 데이터

- 오늘 날짜: !`date '+%Y-%m-%d'`
- 마감일 데이터: !`cat _data/transfer.tsv 2>/dev/null || echo "[없음] _data/transfer.tsv 없음"`
- 에세이 현황: !`find essays -name "*.md" 2>/dev/null | sort | sed 's|^|  |' || echo "  [없음]"`
- 리서치 완료: !`ls research/*.md 2>/dev/null | sed 's|research/||;s|\.md||' | tr '\n' ' ' || echo "없음"`
- 서류 트래커: !`cat documents/tracker.md 2>/dev/null || echo "[없음]"`

---

## 실행 지침

위 데이터를 바탕으로 deadline-planner 에이전트의 플래닝 프로세스를 실행하라.

갭 분석 → 우선순위 산정 → 일별 액션플랜 순으로 출력한다.

## 완료 후 제안

"다음: `/college-transfer:checklist`로 오늘 할 일을 확인하거나, `/college-transfer:research [학교]`로 리서치를 시작하세요."
