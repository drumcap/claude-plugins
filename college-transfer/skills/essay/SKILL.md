---
name: essay
description: 특정 학교의 편입 에세이를 작성하거나 리뷰한다. 학교 이름을 인자로 받는다. 리뷰 요청 시 essay-reviewer 에이전트가 심층 분석을 수행한다.
disable-model-invocation: true
argument-hint: "[school-name]"
---

# /college-transfer:essay $ARGUMENTS - 에세이 작성 도우미

## 자동 수집된 컨텍스트

- 오늘 날짜: !`date '+%Y-%m-%d'`
- 기존 에세이 파일: !`find essays/$ARGUMENTS -name "*.md" 2>/dev/null | sort || echo "없음"`
- 리서치 파일 존재: !`ls research/$ARGUMENTS.md 2>/dev/null && echo "✅ 있음" || echo "❌ 없음 — 에세이 전 /college-transfer:research $ARGUMENTS 권장"`
- 마감일: !`grep "$ARGUMENTS" _data/transfer.tsv 2>/dev/null | awk -F'\t' '{print "Common App:", $3, "/ 서류:", $4}' || echo "TSV 확인 필요"`

---

## 실행 절차

### 1. 상황 파악 및 모드 선택

위 컨텍스트를 바탕으로 현재 상태를 요약하고 메뉴를 제시하라:

```
📝 [$ARGUMENTS] 에세이 도우미
================================
마감: {마감일} (D-{일수})

현재 에세이 상태:
  Why Transfer:    {v? 있음 / 미시작}
  Why This School: {v? 있음 / 미시작} {리서치 없으면 ⚠️}
  Why CS:          {v? 있음 / 미시작}
  Personal Stmt:   {v? 있음 / 미시작}

무엇을 도와드릴까요?
  1. 새 에세이 초안 작성
  2. 기존 에세이 심층 리뷰 (essay-reviewer 에이전트 실행)
  3. 특정 단락 개선
  4. 유형별 가이드 보기
```

### 2. 모드별 처리

#### 모드 1: 새 에세이 초안 작성
transfer-essay 스킬의 에세이 유형별 가이드를 따라 작성.

**리서치 연동**: `research/$ARGUMENTS.md`가 있으면 반드시 읽고 활용.
특히 Why This School은 리서치 없이 절대 작성하지 않는다.

**저장 규칙**:
```
essays/{학교}/{유형}-v{번호}.md
```

YAML frontmatter:
```yaml
---
school: {학교 정식 명칭}
type: {why-transfer|why-school|why-cs|personal-statement}
version: {번호}
word_limit: {제한}
word_count: {실제 단어수}
status: draft
created: {오늘 날짜}
notes: ""
---
```

**버전 관리**: 기존 파일 절대 수정 금지. 항상 새 버전(v1→v2→v3) 생성.

#### 모드 2: 심층 리뷰 (essay-reviewer 에이전트)

리뷰할 에세이 파일을 선택받은 후,
essay-reviewer 에이전트를 호출하여 심층 분석을 수행한다.

리뷰 대상 파일: `essays/$ARGUMENTS/{파일명}`

#### 모드 3: 특정 단락 개선

개선할 단락을 선택받고, 현재 텍스트를 분석한 후
3가지 개선 버전을 제시한다. 선택된 버전으로 새 파일 생성.

### 3. 에세이 유형별 핵심 원칙

#### Why Transfer
- Hook → 현재 한계 → 깨달음 → 새 학교 목표
- 현재 학교 비판 금지, 학문적 갈증 강조
- 300-650 단어

#### Why This School
- 반드시 research/{학교}.md 내용 기반
- 교수명/랩명/과목명 최소 2개 이상 구체적 언급
- 250-500 단어

#### Why CS (또는 전공)
- 구체적 경험 기반, "코딩이 좋아서" 금지
- 현재 전공 → CS 전환의 논리적 필연성
- 250-500 단어

#### Personal Statement
- 이력서 나열 금지, 하나의 이야기에 집중
- 500-650 단어

### 4. 품질 체크 (작성 후 자동 실행)

모든 에세이 저장 전 확인:
- [ ] 단어수 제한 내인가?
- [ ] 첫 문장이 Hook인가?
- [ ] 구체적 사례가 있는가? (추상적 진술 최소화)
- [ ] 학교 이름을 바꾸면 다른 학교에도 쓸 수 있는가? (Yes → Why This School 재작성)

## 출력 후 제안
"저장: `essays/$ARGUMENTS/{파일명}`
다음: `/college-transfer:status`로 전체 현황 확인"
