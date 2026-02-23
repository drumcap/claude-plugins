---
name: research
description: 특정 대학의 CS 편입 프로그램을 자율 리서치한다. 학교 이름을 인자로 받아 전문 에이전트가 독립적으로 웹 리서치를 수행하고 결과를 저장한다.
disable-model-invocation: true
argument-hint: "[school-name]"
context: fork
agent: research-agent
allowed-tools: WebSearch, WebFetch, Read, Write, Glob
---

# /college-transfer:research $ARGUMENTS

## 리서치 대상

학교: **$ARGUMENTS**

## 사전 확인

먼저 다음을 확인하라:
1. `research/$ARGUMENTS.md` 파일이 존재하는지 확인
2. 존재하면: 기존 리서치 날짜와 내용을 요약하여 보여주고 "업데이트하시겠습니까?" 확인
3. 존재하지 않으면: 즉시 리서치 시작

## 학교 이름 매핑

`_data/transfer.tsv`에서 학교 목록을 확인하고 다음 규칙으로 슬러그를 결정:
- 입력값과 가장 유사한 학교를 선택
- 파일명은 소문자 + 하이픈: `ut-austin`, `rice`, `virginia-tech`, `georgia-tech`

## 리서치 실행

research-agent의 리서치 프로세스를 따라 심층 리서치를 수행하라.
완료 후 `research/{슬러그}.md`에 저장.

## 완료 후 출력

```
✅ {학교} 리서치 완료!
저장 위치: research/{슬러그}.md

핵심 포인트 (에세이 즉시 활용 가능):
1. {핵심 포인트 1}
2. {핵심 포인트 2}
3. {핵심 포인트 3}

에세이 작성 준비됨 → /college-transfer:essay $ARGUMENTS
```
