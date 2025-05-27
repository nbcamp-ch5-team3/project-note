
# 📚 WordPalette (워드팔레트)

> **영단어를 쉽고 재미있게 외울 수 있도록 도와주는 다국어 단어 학습 앱**
> **WordPalette**는 단어를 난이도별로 분류하고 색상으로 기억할 수 있도록 도와주는 단어 암기 앱입니다.
> 학습자가 난이도에 맞는 선택하거나 직접 원하는 단어를 추가하여 내 단어장에 나만의 영단어를 저장할 수 있습니다.
> 특히 단어 카드에 퀴즈, 학습 통계, 단어 랜덤 보기 등의 부가 기능을 더해 **재미있게 단어를 외울 수 있는 사용자 경험**을 목표로 개발되었습니다.

---

## 👥 팀 소개

### 🔹 팀명: 조선개발자

### 🎯 팀 목표

> 다양한 기술스택을 학습하고, 이를 적용하여 협업 프로젝트를 완성도 있게 구현해보기

### 🧭 개별 목표

- **박주성**: 스와이프 액션 또는 애니메이션 효과를 사용하여 직관적인 UX 구현
- **유영웅**: iOS 개발의 기초를 탄탄히 다지기
- **이부용**: RxSwift, Clean Architecture를 잘 활용하여 구조화된 앱 제작
- **조선우**: RxSwift 적용 실습

---

## 📌 프로젝트 개요

- **앱명:** WordPalette (워드팔레트)
- **프로젝트 기간:** 2024.05.20 ~ 2024.05.28
- **핵심 기능:** 난이도별 단어장 관리 / 단어 검색 및 추가 / 퀴즈 / 학습 통계 시각화
- **GitHub:** [https://github.com/nbcamp-ch5-team3/project-note](https://github.com/nbcamp-ch5-team3/project-note)
- **컬러 코드:**  
  `#FCC869`  
  `#F39E5E`

---

## 🛠️ 기술 스택 & 개발 환경

* **언어**: Swift
* **UI 프레임워크**: UIKit
* **아키텍처**: 클린 아키텍처 + MVVM
* **데이터 관리**: CoreData

### 외부 라이브러리

* 🧩 **SnapKit** – UI 오토레이아웃 코드 작성
* 🧠 **RxSwift / RxCocoa / RxRelay** – 반응형 프로그래밍
* ✨ **Then** – 인스턴스 초기화 간소화
* 🎞️ **Lottie** – 애니메이션 효과
* 🎹 **IQKeyboardManagerSwift** – 키보드 이슈 해결

---

## ✨ 데모 & 스크린샷

| ![메인화면](이미지URL1) | ![단어추가](이미지URL2) | ![퀴즈](이미지URL3) | ![통계](이미지URL4) |
| :--------------------: | :------------------: | :-------------------: | :-------------------: |
| ![메인화면2](이미지URL5) | ![+버튼추가](이미지URL6) | ![암기미암기체크](이미지URL7) | ![캘린더사용](이미지URL8) |
| ![메인화면3](이미지URL9) | ![직접추가](이미지URL10) | ![번역확인](이미지URL11) | ![날짜확인](이미지URL12) |
| ![메인화면4](이미지URL13) | ![검색하기](이미지URL14) | ![퀴즈탭바선택](이미지URL15) | ![캘린더변화확인](이미지URL16) |

> 이미지URL 자리에 실제 이미지 주소를 넣어주세요!

---

## 📁 폴더 구조 & 역할

```bash
📦WordPalette  
 ┣ 📂App                # 앱 실행 및 DI, 델리게이트 등
 ┃ ┣ 📂DIContainer
 ┃ ┃ ┗ 📝 DIContainer.swift
 ┃ ┣ 📝 AppDelegate.swift
 ┃ ┗ 📝 SceneDelegate.swift
 ┣ 📂Data               # 데이터 관리 (CoreData, 로컬, 저장소 구현)
 ┃ ┣ 📂CoreData
 ┃ ┃ ┣ 📂Object
 ┃ ┃ ┃ ┣ 📝 SolvedWordObject+CoreDataClass.swift
 ┃ ┃ ┃ ┣ 📝 SolvedWordObject+CoreDataProperties.swift
 ┃ ┃ ┃ ┣ 📝 StudyObject+CoreDataClass.swift
 ┃ ┃ ┃ ┣ 📝 StudyObject+CoreDataProperties.swift
 ┃ ┃ ┃ ┣ 📝 UnsolvedWordObject+CoreDataClass.swift
 ┃ ┃ ┃ ┣ 📝 UnsolvedWordObject+CoreDataProperties.swift
 ┃ ┃ ┃ ┣ 📝 UserObject+CoreDataClass.swift
 ┃ ┃ ┃ ┗ 📝 UserObject+CoreDataProperties.swift
 ┃ ┃ ┣ 📝 CoreDataErrorType.swift
 ┃ ┃ ┣ 📝 CoreDataManager.swift
 ┃ ┃ ┣ 📝 CoreDataStack.swift
 ┃ ┃ ┣ 📝 TestCoreDataStack.swift
 ┃ ┃ ┗ 📄 WordPalette.xcdatamodeld
 ┃ ┣ 📂LocalDataSource
 ┃ ┃ ┣ 📂json
 ┃ ┃ ┣ 📝 Level+FileName.swift
 ┃ ┃ ┣ 📝 WordItem.swift
 ┃ ┃ ┗ 📝 WordLocalDataSource.swift
 ┃ ┗ 📂RepositoryImpl
 ┃   ┣ 📝 SolvedWordRepositoryImpl.swift
 ┃   ┣ 📝 UnsolvedWordRepositoryImpl.swift
 ┃   ┗ 📝 UserRepositoryImpl.swift
 ┣ 📂Domain             # 비즈니스 로직, 엔티티, 리포지토리, 유스케이스
 ┃ ┣ 📂Entity
 ┃ ┃ ┣ 📝 Level.swift
 ┃ ┃ ┣ 📝 StudyHistory.swift
 ┃ ┃ ┣ 📝 TierType.swift
 ┃ ┃ ┣ 📝 UserData.swift
 ┃ ┃ ┗ 📝 WordEntity.swift
 ┃ ┣ 📂Repository
 ┃ ┃ ┣ 📝 SolvedWordRepository.swift
 ┃ ┃ ┣ 📝 UnsolvedWordRepository.swift
 ┃ ┃ ┗ 📝 UserRepository.swift
 ┃ ┗ 📂UseCase
 ┃   ┣ 📂AddWord
 ┃   ┃ ┣ 📝 AddWordUseCase.swift
 ┃   ┃ ┗ 📝 AddWordUseCaseImpl.swift
 ┃   ┣ 📂QuizUseCase
 ┃   ┃ ┣ 📝 QuizUseCase.swift
 ┃   ┃ ┗ 📝 QuizUseCaseImpl.swift
 ┃   ┣ 📂StudyHistoryUseCase
 ┃   ┃ ┣ 📝 StudyHistoryUseCase.swift
 ┃   ┃ ┗ 📝 StudyHistoryUseCaseImpl.swift
 ┃   ┗ 📂UnsolvedMyWordUseCase
 ┃     ┣ 📝 UnsolvedMyWordUseCase.swift
 ┃     ┗ 📝 UnsolvedMyWordUseCaseImpl.swift
 ┣ 📂Presentation       # 화면(UI), 뷰모델, 뷰컨트롤러 등
 ┃ ┣ 📂AddWord
 ┃ ┃ ┣ 📂View
 ┃ ┃ ┃ ┣ 📂Cell
 ┃ ┃ ┃ ┃ ┣ 📝 AddWordModalView.swift
 ┃ ┃ ┃ ┃ ┗ 📝 AddWordView.swift
 ┃ ┃ ┣ 📂ViewController
 ┃ ┃ ┃ ┣ 📝 AddWordModalViewController.swift
 ┃ ┃ ┃ ┗ 📝 AddWordViewController.swift
 ┃ ┃ ┗ 📂ViewModel
 ┃ ┃   ┗ 📝 AddWordViewModel.swift
 ┃ ┣ 📂Home
 ┃ ┃ ┣ 📂View
 ┃ ┃ ┃ ┗ 📝 HomeView.swift
 ┃ ┃ ┣ 📂ViewController
 ┃ ┃ ┃ ┗ 📝 HomeViewController.swift
 ┃ ┃ ┗ 📂ViewModel
 ┃ ┃   ┗ 📝 HomeViewModel.swift
 ┃ ┣ 📂MyStudy
 ┃ ┃ ┣ 📂Cell
 ┃ ┃ ┃ ┗ 📝 StudyWordCell.swift
 ┃ ┃ ┣ 📂Utils
 ┃ ┃ ┃ ┣ 📂Mock
 ┃ ┃ ┃ ┃ ┣ 📝 UserDataMock.swift
 ┃ ┃ ┃ ┃ ┗ 📝 WordEntityMock.swift
 ┃ ┃ ┃ ┗ 📂Protocol
 ┃ ┃ ┃   ┣ 📝 UIViewGuide.swift
 ┃ ┃ ┃   ┗ 📝 ViewModelType.swift
 ┃ ┃ ┣ 📂View
 ┃ ┃ ┃ ┣ 📝 ProfileSectionView.swift
 ┃ ┃ ┃ ┣ 📝 StatLabel.swift
 ┃ ┃ ┃ ┣ 📝 StudyHistoryView.swift
 ┃ ┃ ┃ ┗ 📝 StudyStatisticsView.swift
 ┃ ┃ ┣ 📂ViewController
 ┃ ┃ ┃ ┣ 📝 StudyHistoryViewController.swift
 ┃ ┃ ┃ ┗ 📝 StudyStatisticsViewController.swift
 ┃ ┃ ┗ 📂ViewModel
 ┃ ┃   ┣ 📝 StudyHistoryViewModel.swift
 ┃ ┃   ┗ 📝 StudyStatisticsViewModel.swift
 ┃ ┗ 📂Quiz
 ┃   ┣ 📂Components
 ┃   ┃ ┣ 📝 QuizCardStackView.swift
 ┃   ┃ ┣ 📝 QuizCardView.swift
 ┃   ┃ ┗ 📝 QuizStatusView.swift
 ┃   ┣ 📂Model
 ┃   ┃ ┣ 📝 QuizViewInfo.swift
 ┃   ┃ ┣ 📝 QuizView.swift
 ┃   ┃ ┣ 📝 QuizViewController.swift
 ┃   ┃ ┗ 📝 QuizViewModel.swift
 ┃   ┗ 📂Shared
 ┣ 📂Resource           # 리소스(애셋, Lottie, Info 등)
 ┃ ┣ 📂Lottie
 ┃ ┃ ┣ 🎞️ CelebrationAnimation.json
 ┃ ┃ ┣ 🎞️ CoolEmojiAnimation.json
 ┃ ┃ ┗ 🎞️ RaisedEmojiAnimation.json
 ┃ ┣ 🖼️ Assets.xcassets
 ┃ ┣ 📝 Info.plist
 ┃ ┗ 📝 LaunchScreen.storyboard
 ┣ 📂WordPaletteTests   # 단위 테스트
 ┗ 📂WordPaletteUITests # UI 테스트
```

> 각 폴더 역할은 # 주석 참고해서 간단히 확인할 수 있어요!

---

## ✍️ 주요 기능 상세 설명 (사용자 시점)

### 🏠 메인화면 (HomeView)
- 난이도별 버튼(초급/중급/고급)으로 내 단어장 분리
- "단어 추가" 버튼 클릭 시 해당 레벨 단어 추가 페이지로 이동
- 내가 추가한 단어가 리스트 형식으로 정리됨 (TableView Cell)
- 스와이프 액션으로 단어 개별 삭제 가능
- 전체 삭제 버튼으로 레벨별 단어 전체 삭제 가능

### 🔍 단어 검색 및 추가 화면 (SearchView)
- 한국어 또는 영어로 단어 검색 가능
- 랜덤 20개 출력, Pull-To-Refresh 시 랜덤 20개 재생성
- 원하는 단어가 없다면 수동 추가(단어, 뜻, 예문)
- 단어 추가하면 CoreData에 저장되어 추후 퀴즈/리스트에 반영
- 긴 단어는 셀 자동 높이 조절로 UI 안정화

### 🎴 단어 퀴즈 (QuizView)
- 내가 저장한 단어를 예문 기반으로 퀴즈 형식 제공
- 난이도 별로 구분하여 퀴즈 가능
- 플래시카드 스타일로 좌우 스와이프  
  - 왼쪽: 외우지 못한 단어  
  - 오른쪽: 외운 단어로 분류
- 남은 단어, 암기 단어, 미암기 단어 실시간 확인

### 📊 나의 학습 뷰 (MyPageView)
- 현재 티어와 점수, 다음 티어까지 남은 점수 시각화
- 캘린더 형태로 학습 이력 한눈에 확인 가능
- 특정 날짜 선택 시 해당 날짜 학습률/암기율 확인 가능
- 암기 / 미암기 / 전체 필터에 따른 단어 리스트 제공 

---

## 👨‍👩‍👧‍👦 팀원 / 역할 분담

| 이름   | 담당 역할                                               |
| ------ | ------------------------------------------------------ |
| 박주성 | CoreDataManager, 퀴즈 화면 전체 구현                     |
| 유영웅 | 나의 학습 화면 구현, 날짜별 암기/미암기 리스트 뷰 구현    |
| 이부용 | 단어 추가, Modal 화면 구현 및 검색 필터링 구현 |
| 조선우 | 메인 화면 구성 및 네비게이션 구조 설정                   |
| **공통** | SA 작성, 스크럼 일지, QnA 정리, 발표 자료, 시연 영상 제작 등 |

---

## 🔮 향후 개발 계획

- 퀴즈 유형 다양화 및 난이도별 자동 출제
- 다크모드 지원
- iCloud 동기화
- 위젯/알림 기능 추가

---

## 🔗 참고 링크

- 📄 [Figma 와이어프레임](https://www.figma.com/design/Aweo8xoGZuOiXdRqSmE3wY/%EC%A1%B0%EC%84%A0%EA%B0%9C%EB%B0%9C%EC%9E%90?node-id=0-1&p=f&t=uniDmmHbI9GyJLAt-0)
- 📄 [SA 노션 문서](https://misty-specialist-938.notion.site/1f9961f63ff580f58581e23d147fac6e?pvs=74)

---

> 함께 만들어가는 조선개발자의 첫 번째 프로젝트. 🌟  
> 문의 및 피드백은 [GitHub Issue](https://github.com/nbcamp-ch5-team3/project-note/issues)로 남겨주세요!
> **조선개발자, 화이팅!** 🚀
