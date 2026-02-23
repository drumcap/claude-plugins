# College Transfer Plugin for Claude Code

미국 대학 편입(Transfer) 지원 준비를 위한 Claude Code 플러그인입니다.

에세이 작성, CS 프로그램 리서치, 마감일 관리, 진행 현황 대시보드를 하나의 플러그인으로 제공합니다.

## 포함된 스킬

| 스킬 | 명령어 | 설명 |
|------|--------|------|
| status | `/college-transfer:status` | 전체 지원 현황 대시보드 |
| deadline | `/college-transfer:deadline` | 마감일 타임라인 |
| essay | `/college-transfer:essay [학교]` | 에세이 작성 도우미 |
| research | `/college-transfer:research [학교]` | CS 프로그램 리서치 |
| checklist | `/college-transfer:checklist` | 우선순위 할일 목록 |
| transfer-essay | (자동 활성화) | 편입 에세이 전문가 지식 |

## 설치 방법

### 방법 1: 마켓플레이스로 설치 (권장)

```shell
# 마켓플레이스 등록
/plugin marketplace add https://github.com/drumcap/claude-plugins

# 플러그인 설치
/plugin install college-transfer@college-transfer-marketplace
```

### 방법 2: 로컬에서 직접 실행

```bash
# 레포 클론
git clone https://github.com/drumcap/claude-plugins
cd claude-plugins

# 플러그인 디렉토리로 Claude Code 실행
claude --plugin-dir ./
```

### 방법 3: 프로젝트에 포함 (팀 공유)

`.claude/settings.json`에 추가:

```json
{
  "extraKnownMarketplaces": {
    "college-transfer-marketplace": {
      "source": {
        "source": "github",
        "repo": "drumcap/claude-plugins"
      }
    }
  },
  "enabledPlugins": {
    "college-transfer@college-transfer-marketplace": true
  }
}
```

## 프로젝트 초기 설정

이 플러그인은 편입 지원 프로젝트 디렉토리에서 사용합니다. 다음 구조로 프로젝트를 설정하세요:

```
my-transfer-prep/
├── _data/
│   └── transfer.tsv        # 학교 정보 (아래 형식 참조)
├── essays/
│   ├── common/             # 공통 내러티브 자료
│   ├── rice/               # 학교별 에세이
│   ├── ut-austin/
│   └── ...
├── research/
│   ├── rice.md             # 학교별 리서치 (자동 생성)
│   └── ...
└── documents/
    └── tracker.md          # 서류 제출 트래커
```

### `_data/transfer.tsv` 형식

```tsv
School	Short	Common App DEADLINE	Document DeadLine	Transcript Due1	CS Program URL
Rice University	rice	2025-03-15	2025-03-15	2025-03-15	https://cs.rice.edu/
UT Austin	ut-austin	2025-03-01	2025-03-10	2025-03-10	https://www.cs.utexas.edu/
Virginia Tech	virginia-tech	2025-03-01	2025-03-11	2025-03-11	https://cs.vt.edu/
Georgia Tech	georgia-tech	2025-03-02	2025-03-16	2025-03-16	https://www.cc.gatech.edu/
```

### `documents/tracker.md` 형식

```markdown
# 서류 제출 트래커

| 서류 | Rice | UT Austin | Virginia Tech | Georgia Tech |
|------|------|-----------|---------------|--------------|
| 지원서 | ⬜ | ⬜ | ⬜ | ⬜ |
| 성적증명서 | ⬜ | ⬜ | ⬜ | ⬜ |
| 이력서 | ⬜ | ⬜ | ⬜ | ⬜ |
| 추천서 | ⬜ | ⬜ | ⬜ | ⬜ |

상태: ⬜ 미시작 / 🔄 진행중 / ✅ 제출완료 / 📬 수령확인
```

## 사용법

### 현황 확인

```shell
# 전체 현황 대시보드
/college-transfer:status

# 마감일 타임라인
/college-transfer:deadline

# 오늘 할일 체크리스트
/college-transfer:checklist
```

### 리서치 → 에세이 작성 워크플로우

```shell
# 1. 학교 리서치 먼저
/college-transfer:research rice

# 2. 리서치 바탕으로 에세이 작성
/college-transfer:essay rice

# 3. 현황 업데이트 확인
/college-transfer:status
```

### 에세이 학교 이름 매핑

| 키워드 | 학교 |
|--------|------|
| `rice` | Rice University |
| `ut-austin`, `ut`, `texas` | UT Austin |
| `virginia-tech`, `vt` | Virginia Tech |
| `georgia-tech`, `gt`, `gatech` | Georgia Tech |

## 커스터마이즈

다른 학교를 지원하는 경우 `_data/transfer.tsv`에 학교를 추가하면 모든 스킬이 자동으로 해당 학교를 인식합니다.

에세이 디렉토리도 `essays/{school-short-name}/`로 생성하면 됩니다.

## 요구사항

- Claude Code 최신 버전
- 인터넷 연결 (research 스킬의 웹 검색에 필요)

## 라이선스

MIT License
