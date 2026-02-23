---
name: deadline
description: 편입 지원 마감일 타임라인을 출력한다. 오늘 날짜 기준 D-day를 계산하여 긴급도 순으로 표시한다.
disable-model-invocation: true
---

# /college-transfer:deadline - 마감일 타임라인

## 자동 수집된 컨텍스트

- 오늘 날짜: !`date '+%Y-%m-%d'`
- Unix 타임스탬프 (D-day 계산용): !`date '+%s'`

### 학교 마감일 데이터 (_data/transfer.tsv)
!`cat _data/transfer.tsv 2>/dev/null || echo "[오류] _data/transfer.tsv 파일이 없습니다."`

---

## 실행 지침

위 데이터를 바탕으로 각 학교의 마감일까지 남은 일수(D-day)를 계산하고,
긴급도 순으로 정렬하여 다음 형식으로 출력하라.

오늘 날짜와 마감일 사이의 일수 = (마감일 - 오늘) 일수

### 출력 형식

```
📅 편입 마감일 타임라인
====================
오늘: {오늘 날짜}

🔴 긴급 (D-10 이하)
  {학교명:<15} | Common App: {날짜} | D-{일수} | 서류마감: {날짜}

🟡 임박 (D-11 ~ D-20)
  {학교명:<15} | Common App: {날짜} | D-{일수} | 서류마감: {날짜}

🟢 여유 (D-21 이상)
  {학교명:<15} | Common App: {날짜} | D-{일수} | 서류마감: {날짜}

❌ 마감 지남
  {학교명:<15} | 마감: {날짜} | {일수}일 전 마감

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️  다음 마감: {가장 가까운 마감} (D-{일수})
💡  지금 집중: {가장 급한 미완료 작업}
```

## TSV 컬럼 참조
- `Common App DEADLINE`: 지원서 제출 마감
- `Document DeadLine`: 서류 제출 마감

## 출력 후 제안
"다음: `/college-transfer:status`로 전체 현황을 확인하거나, `/college-transfer:checklist`로 오늘 할 일을 확인하세요."
