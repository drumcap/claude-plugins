---
name: help
description: college-transfer 플러그인의 모든 명령어, 에이전트, 스킬 목록과 권장 워크플로우를 보여준다.
disable-model-invocation: true
---

# /college-transfer:help - 전체 명령어 가이드

다음 내용을 그대로 출력하라:

---

## 📖 college-transfer 명령어 가이드

### 현황 파악

| 명령어 | 설명 |
|--------|------|
| `/college-transfer:status` | 전체 지원 현황 대시보드 |
| `/college-transfer:deadline` | 마감일 타임라인 (D-day 기준 정렬) |
| `/college-transfer:checklist` | 오늘의 우선순위 할일 목록 |
| `/college-transfer:plan` | 마감일까지 최적 주간 액션플랜 (deadline-planner 에이전트) |

### 리서치 & 에세이

| 명령어 | 설명 |
|--------|------|
| `/college-transfer:research [학교]` | 학교 CS 프로그램 심층 리서치 (research-agent) |
| `/college-transfer:essay [학교]` | 에세이 작성 / 리뷰 메뉴 |
| `/college-transfer:write [학교]` | essay-writer 에이전트로 에세이 자율 작성 |
| `/college-transfer:review [파일경로]` | essay-reviewer 에이전트로 에세이 심층 분석 |

### 병렬 자동화 (Agent Teams)

| 명령어 | 설명 |
|--------|------|
| `/college-transfer:cowork` | 전체 워크플로우 병렬 실행 (리서치+에세이+리뷰) |
| `/college-transfer:cowork research` | 리서치만 병렬 실행 |
| `/college-transfer:cowork essay` | 에세이 작성만 병렬 실행 |
| `/college-transfer:cowork review` | 리뷰만 병렬 실행 |

---

### 에이전트 목록

| 에이전트 | 역할 | 호출 명령어 |
|----------|------|-------------|
| `research-agent` | 대학 CS 프로그램 웹 리서치 | `/college-transfer:research` |
| `essay-writer` | 편입 에세이 자율 작성 | `/college-transfer:write` |
| `essay-reviewer` | 에세이 7개 차원 심층 분석 | `/college-transfer:review` |
| `deadline-planner` | 최적 주간 액션플랜 수립 | `/college-transfer:plan` |
| `team-lead` | 전체 워크플로우 조율 (멀티 에이전트) | `/college-transfer:cowork` |

---

### 권장 워크플로우

```
1️⃣  현황 파악     /college-transfer:status
2️⃣  계획 수립     /college-transfer:plan
3️⃣  리서치        /college-transfer:research [학교]
4️⃣  에세이 작성   /college-transfer:write [학교]
5️⃣  에세이 리뷰   /college-transfer:review essays/[학교]/[파일명]
6️⃣  병렬 자동화   /college-transfer:cowork
```

**빠른 시작**: `/college-transfer:status` → `/college-transfer:plan`
