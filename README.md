
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

| [메인화면] | [단어추가] | [퀴즈] | [나의학습(통계)] |
| :--------------------: | :------------------: | :-------------------: | :-------------------: |
| 난이도 확인![난이도확인](https://github.com/user-attachments/assets/3ccf0fb0-1c44-4fc8-9bab-af44ecc43cde) | +버튼추가![+버튼추가](https://github.com/user-attachments/assets/107e19b4-1977-4ea3-9403-0763b69d8704) | 레벨선택학습![난이도선택](https://github.com/user-attachments/assets/68e5a30b-4c2d-4b37-bd97-3c95be455f22) | 캘린더사용![캘린더사용](https://github.com/user-attachments/assets/7bb50ebb-2937-4e85-aa1d-9969302e25b7) |
| 개별삭제![개별삭제](https://github.com/user-attachments/assets/095b38e6-1387-47ed-b52c-4be040182d8c) | 직접단어추가![직접단어추가](https://github.com/user-attachments/assets/4c42e7d1-857a-4763-a503-050f867385d6) | 암기미암기체크![암기미암기체크](https://github.com/user-attachments/assets/a1a0e717-a738-481c-b5ae-7ec476486573) | 학습내용확인![학습내용확인](https://github.com/user-attachments/assets/6e88555d-018d-419f-94c3-1edc12b787d8) |
| 전체삭제![전체삭제](https://github.com/user-attachments/assets/35568805-cce0-442c-94d6-f9021863600c) | 검색하기![검색하기](https://github.com/user-attachments/assets/f131bff3-8b11-4a3a-bc39-fb1b4a9478f1) | 번역확인![번역확인](https://github.com/user-attachments/assets/5e8db9e2-c170-470a-94a2-38cdf3f5c16a) | 레벨변화![레벨변화](https://github.com/user-attachments/assets/d06031fd-5646-4f71-b229-74b569cac9fc) 

---

## 📁 폴더 구조 & 역할

### 🗂️ 요약된 폴더 구조

```bash
📦WordPalette
 ┣ 📂App              # 앱 실행, DI, 라이프사이클 관리
 ┣ 📂Data             # 데이터 계층(CORE DATA, 로컬, 저장소 구현체)
 ┃ ┣ 📂CoreData           # CoreData 엔티티 및 스택, 매니저
 ┃ ┣ 📂LocalDataSource    # 로컬(json) 데이터 관리
 ┃ ┗ 📂RepositoryImpl     # 데이터 저장소 구현체
 ┣ 📂Domain           # 비즈니스 로직(엔티티, 리포지토리, 유스케이스)
 ┃ ┣ 📂Entity              # 핵심 데이터 구조 정의
 ┃ ┣ 📂Repository          # 도메인 저장소 인터페이스
 ┃ ┗ 📂UseCase             # 유스케이스(비즈니스 로직)
 ┣ 📂Presentation     # UI, 화면, 뷰모델, 뷰컨트롤러
 ┃ ┣ 📂AddWord             # 단어 추가 화면
 ┃ ┣ 📂Home                # 메인(홈) 화면
 ┃ ┣ 📂MyStudy             # 학습 이력/통계 화면
 ┃ ┗ 📂Quiz                # 퀴즈 화면 및 컴포넌트
 ┣ 📂Resource         # 리소스(애셋, Lottie, Info 등)
 ┃ ┣ 📂Lottie              # Lottie 애니메이션 파일
 ┃ ┣ 🖼️ Assets.xcassets     # 이미지 에셋
 ┃ ┣ 📝 Info.plist          # 앱 정보 설정
 ┃ ┗ 📝 LaunchScreen.storyboard # 런치 스크린
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
