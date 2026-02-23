---
name: status
description: 편입 지원 전체 현황 대시보드를 출력한다. 학교별 진행률, 에세이 현황, 서류 상태를 한눈에 보여준다.
disable-model-invocation: true
---

# /college-transfer:status - 전체 지원 현황 대시보드

## 자동 수집된 컨텍스트

- 오늘 날짜: !`date '+%Y-%m-%d'`
- 요일: !`date '+%A'`

### 학교 데이터 (_data/transfer.tsv)
!`cat _data/transfer.tsv 2>/dev/null || echo "[오류] _data/transfer.tsv 파일이 없습니다. 프로젝트 초기 설정을 확인하세요."`

### 에세이 파일 현황 (essays/)
!`find essays -name "*.md" 2>/dev/null | sort | sed 's|^|  |' || echo "  [없음]"`

### 서류 트래커 (documents/tracker.md)
!`cat documents/tracker.md 2>/dev/null || echo "[없음] documents/tracker.md 파일이 없습니다."`

---

## 실행 지침

위 자동 수집된 컨텍스트를 바탕으로 다음 형식의 대시보드를 한국어로 출력하라.
파일이 없는 항목은 "미시작"으로 표시한다.

### 출력 형식

```
편입 지원 현황 대시보드
================================
오늘: {날짜} | 첫 마감까지: D-{계산값}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
학교별 현황

{D-day 기준 색상 이모지} {학교명} (마감: M/D, D-{계산값})
  ✅/❌ 지원서 제출
  📝 에세이: {유형별 버전 또는 미시작}
  📄 성적증명서: {tracker.md 상태}
  전체 진행률: {바 그래프} {%}

...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
에세이 매트릭스

| 유형            | {학교1} | {학교2} | ... |
|-----------------|---------|---------|-----|
| Why Transfer    |         |         |     |
| Why This School |         |         |     |
| Why CS          |         |         |     |
| Personal Stmt   |         |         |     |

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚨 즉시 처리 필요
  {마감 임박 + 미완료 항목}

💡 오늘의 권고 작업
  1. {가장 급한 마감 기준}
  2. {두 번째 권고}
```

## D-day 색상 기준
- 🔴 D-10 이하: 긴급
- 🟡 D-11~D-20: 임박
- 🟢 D-21 이상: 여유
- ❌ 마감 지남

## 에세이 상태 판단
- essays/{school}/ 디렉토리의 파일명에서 버전(v1, v2...) 추출
- YAML frontmatter의 status 필드: draft/review/final

## 출력 후 제안
"다음: `/college-transfer:checklist`로 오늘 할 일을 확인하거나, `/college-transfer:essay [학교]`로 에세이를 시작하세요."
