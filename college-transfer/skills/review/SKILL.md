---
name: review
description: 에세이 파일을 심층 분석한다. 파일 경로를 인자로 받아 essay-reviewer 에이전트가 독립적으로 분석하고 구체적 피드백을 제공한다.
disable-model-invocation: true
argument-hint: "[essay-file-path]"
context: fork
agent: essay-reviewer
allowed-tools: Read, Glob
---

# /college-transfer:review $ARGUMENTS

## 리뷰 대상

파일: **$ARGUMENTS**

## 사전 정보 수집

- 리뷰 파일: !`cat "$ARGUMENTS" 2>/dev/null || echo "[오류] 파일을 찾을 수 없습니다: $ARGUMENTS"`
- 학교 리서치: !`cat "research/$(echo "$ARGUMENTS" | awk -F'/' '{print $2}').md" 2>/dev/null | head -50 || echo "[리서치 없음]"`

## 리뷰 실행

essay-reviewer 에이전트의 7개 차원 분석 프레임워크를 따라
위 에세이를 심층 분석하고 구체적 피드백을 제공하라.

---

사용 예시:
```
/college-transfer:review essays/rice/why-transfer-v1.md
/college-transfer:review essays/ut-austin/why-school-v2.md
```
