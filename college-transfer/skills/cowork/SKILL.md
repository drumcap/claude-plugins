---
name: cowork
description: Agent Teams를 사용해 여러 학교의 리서치와 에세이 작성을 병렬로 실행한다. 학교 수만큼 teammate를 동시에 생성하여 전체 편입 준비 워크플로우를 자동화한다.
disable-model-invocation: true
---

# /college-transfer:cowork - Agent Teams 병렬 워크플로우

## 사전 준비 정보

- 오늘 날짜: !`date '+%Y-%m-%d'`
- 지원 학교 목록: !`awk -F'\t' 'NR>1 && $1!="" {print $1, "|", $2, "| 마감:", $3}' _data/transfer.tsv 2>/dev/null || echo "_data/transfer.tsv 없음"`
- 리서치 완료: !`ls research/*.md 2>/dev/null | sed 's|research/||;s|\.md||' | tr '\n' ' ' || echo "없음"`
- 에세이 현황: !`find essays -name "*.md" 2>/dev/null | wc -l | tr -d ' '`개 파일

---

## 실행 지침

위 데이터를 바탕으로 Agent Teams를 구성하여 편입 준비를 병렬로 진행하라.
**반드시 team-lead 에이전트로 팀을 조율하라.**

### Step 1: 팀 구성 계획 수립 및 사용자 확인

현재 상태를 분석하고 다음 형식으로 실행 계획을 제시한 뒤 사용자 승인을 받아라:

```
🤝 Agent Teams 편입 준비 플랜
================================
팀 구성: {총 teammate 수}명
예상 소요: {병렬 실행이므로 가장 긴 작업 시간}

Phase 1: 리서치 (병렬) — {n}개 teammate
{리서치 필요 학교 목록}

Phase 2: 에세이 작성 (병렬) — {n}개 teammate
{작성할 에세이 학교 + 유형 목록}

Phase 3: 리뷰 (병렬) — {n}개 teammate
{리뷰할 에세이 파일 목록}

⚠️ 주의: Agent Teams는 토큰을 많이 사용합니다.
실행하시겠습니까? (진행/취소)
```

### Step 2: 팀 생성

사용자 승인 후:

```
"Create an agent team with team-lead as coordinator.

Team structure:
- 1 team lead (using team-lead agent)
- {n} research teammates (one per school needing research)
- {n} essay-writer teammates (one per school, after research)
- {n} essay-reviewer teammates (one per completed essay)

Team lead instructions:
Read _data/transfer.tsv, identify schools, coordinate parallel research
and essay writing following the team-lead agent protocol.
Require plan approval before essay writing begins."
```

### Step 3: 모니터링 안내

팀 생성 후 사용자에게 안내:
```
🔄 팀 실행 중...

모니터링 방법:
- Shift+Down: 각 teammate 세션으로 이동
- 팀 리드 세션: 전체 진행 현황
- 각 teammate: 개별 작업 진행

완료 후 팀 리드가 자동으로 최종 현황을 보고합니다.
```

## 단계별 실행 옵션

전체 실행 대신 특정 Phase만 실행할 수 있다:

```
/college-transfer:cowork research   → Phase 1만 (리서치 병렬)
/college-transfer:cowork essay      → Phase 2만 (에세이 병렬)
/college-transfer:cowork review     → Phase 3만 (리뷰 병렬)
```

`$ARGUMENTS`가 있으면 해당 Phase만 실행한다.

## 비용 안내

Agent Teams는 각 teammate가 독립적인 Claude 세션이므로 토큰 비용이 학교 수에 비례합니다.
- 학교 4개 기준: 리서치 4 + 에세이 4 + 리뷰 8 = 16 teammate 세션
- 단일 세션 대비 약 8-16배 토큰 사용
- 대신 작업 시간은 학교 수와 무관하게 단일 학교 시간과 동일

빠른 마감이 임박한 경우 효과가 극대화됩니다.
