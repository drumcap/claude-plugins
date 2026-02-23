---
name: write
description: essay-writer 에이전트가 특정 학교의 편입 에세이를 자율 작성하고 저장한다. 학교 이름을 인자로 받는다.
disable-model-invocation: true
argument-hint: "[school-name]"
context: fork
agent: essay-writer
allowed-tools: Read, Write, Glob
---

# /college-transfer:write $ARGUMENTS

## 사전 준비 정보

- 학교: **$ARGUMENTS**
- 오늘 날짜: !`date '+%Y-%m-%d'`
- 마감일: !`grep -i "$ARGUMENTS" _data/transfer.tsv 2>/dev/null | awk -F'\t' '{print "Common App:", $3, "/ 서류:", $4}' || echo "TSV 확인 필요"`
- 리서치 파일: !`cat "research/$ARGUMENTS.md" 2>/dev/null | head -30 || echo "[없음] → /college-transfer:research $ARGUMENTS 먼저 실행 권장"`
- 기존 에세이: !`find "essays/$ARGUMENTS" -name "*.md" 2>/dev/null | sort | sed 's|^|  |' || echo "  [없음] — 처음 작성"`
- Why Transfer 공통 내러티브: !`cat essays/common/why-transfer-narrative.md 2>/dev/null | head -20 || echo "[없음]"`

---

## 실행 지침

essay-writer 에이전트 프로토콜을 따라 **$ARGUMENTS** 학교의 에세이를 작성하라.

### 독립 실행 모드 (팀 없음)

이 세션은 팀 리드 없이 단독으로 실행된다.
essay-writer 에이전트의 작업 프로세스를 그대로 따르되,
팀 리드 보고 단계는 생략하고 작업 완료 후 직접 완료 요약을 출력한다.

### 작성 순서

기존 에세이 파일을 확인하고, 아직 작성되지 않은 유형부터 작성한다:
1. Why Transfer (공통 내러티브 활용)
2. Why This School (리서치 파일 필수 — 없으면 작성 전 사용자에게 안내)
3. Why CS / Personal Statement (선택적)

### 완료 후 출력

```
✅ $ARGUMENTS 에세이 작성 완료!

작성된 파일:
  {파일경로} — {단어수}/{제한} words ({상태})
  ...

다음 단계:
  리뷰:    /college-transfer:review essays/$ARGUMENTS/{파일명}
  현황:    /college-transfer:status
```
