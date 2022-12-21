# Daily Quest 🧩

![Group_36](https://user-images.githubusercontent.com/26710036/207524292-bf21d9d8-7738-4ea2-9bab-db4f513d5a71.png)

<a href="https://apps.apple.com/kr/app/apple-store/id6444737672"><img src="https://user-images.githubusercontent.com/53684146/209014894-ec8d5bba-8282-4410-ac29-ffcb3863ddb9.png"/></a>

잊지 말아야 할 하루의 퀘스트, Daily Quest와 함께  🧩


# Features 👏

<table width="100%">
    <tr>
      <td width="25%" align="center">😃 달성하고자 하는 퀘스트들을 등록해보세요!</td>
      <td width="25%" align="center">✅ 캘린더를 통해 퀘스트를 확인할 수 있습니다!</td>
      <td width="25%" align="center">👀 다른 사람들의 퀘스트들을 둘러보세요!</td>
      <td width="25%"  align="center">🤼‍♀️ 다른 사람의 전체 퀘스트도 확인할 수 있어요!</td>
    </tr>
    <tr>
      <td width="25%"  align="center"><img src="https://user-images.githubusercontent.com/26710036/207527078-4bebd25f-1337-4dff-911e-45d9e2362fa1.gif" /></td>
      <td width="25%"  align="center"><img src="https://user-images.githubusercontent.com/26710036/207528844-964cf81e-0597-4a67-826d-625dd51de6f4.gif" /></td>
      <td width="25%"  align="center"><img src="https://user-images.githubusercontent.com/26710036/207528731-8b6bea5b-4a60-414e-9b63-921b36bde368.gif" /></td>
      <td width="25%"  align="center"><img src="https://user-images.githubusercontent.com/26710036/207528793-a67e4940-607c-48ab-8937-ef9240e7ab7a.gif" /></td>
    </tr>
</table>



# Stacks 🧑‍💻

## MVVM-C & Clean Architecture

![Frame 9](https://user-images.githubusercontent.com/26710036/207525159-3629e537-5270-4b48-b60f-158525a9a333.png)

- 어플을 기획하면서 한곳에서 다른 여러곳으로 이동할 수 있는 View가 생겼고, 화면을 전환하는 역할을 해당 ViewController가 처리하면, 코드량이 길어져 가독성이 떨어지고, 역할과 책임에 대해 생각해보아야할 필요가 있다는 판단하에 Coordinator를 도입하였습니다.
- 의존성 주입과 관련된 부분을 DI 컨테이너를 통해 진행하면서 각 ViewController들을 이에 해당하는 역할과 책임에서 자유롭게 할 수 있었습니다.
- 원활한 프로젝트 진행을 하는데 있어서 6주라는 기간을 효율적으로 사용하여 개발할 수 있는 방법이라 생각하고 채택하였습니다.
- 각 레이어별로 개발을 진행할 때, 다른 레이어의 추상화된 인터페이스만 생각하고 개발하였습니다.
- 레이어별로 분리가 되었기에 테스트 코드 작성이 용이해졌습니다.

## RxSwift

- MVVM 패턴을 사용함에 따라, 데이터 바인딩 방식을 Combine, RxSwift, 그리고 자체 구현으로 처리할 필요가 있어서 많은 곳에서 사용중인 RxSwift를 채택하였습니다.
- Firebase에서 비동기로 받는 데이터들을 클로저가 아닌 return 형식으로 받아서 간단하게 처리하고, 에러도 쉽게 처리하기 위해서 채택하였습니다.

## Firebase & Realm

- 퀘스트들을 데이터로 저장하는 데에 있어 **안정성**을 더해주기 위해 **서버 데이터 베이스(Firebase)**와 **로컬 데이터 베이스(Realm)**를 사용하였습니다.
- **다양한 기술 스택**을 이용해보는 것을 이번 프로젝트의 목표로 잡았고, 애플이 지원해주는 라이브러리가 아닌 외부의 라이브러리를 선택해보기로하여 **Realm**을 채택하게 되었습니다.

![Frame 10](https://user-images.githubusercontent.com/26710036/207525512-01ef9e47-409c-4e59-b78d-948ace96f7ae.png)

- 6주라는 짧은 개발 기간 동안 프로젝트를 구현하기 위해 서버 구축이 아닌 **손쉽게 사용**할 수 있는 **Firebase**를 채택하였습니다.
    
![Untitled 3](https://user-images.githubusercontent.com/26710036/207525678-40517feb-aefc-419c-a933-5a8a5414859e.png)    

# Design 🖌️

- 개발을 진행하기에 앞서 피그마를 통해 프로젝트의 레이아웃을 구성하여 구체화하였습니다.
- Daily Quest의 메인 캐릭터인 맥스를 디자인하여 Daily Quest만의 아이덴티티를 부여하였습니다.

<img width="689" alt="%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-12-02_18 19 22" src="https://user-images.githubusercontent.com/26710036/207525776-a83b63e2-43a2-4be1-a499-e92d8d264560.png">

# Team 👥

|S014_김진웅|S017_박동훈|S036_이다연|S042_이전희|S000_맥스|
|:-:|:-:|:-:|:-:|:-:|
|<img src="https://avatars.githubusercontent.com/u/26710036?v=4" width=460 />|<img src="https://avatars.githubusercontent.com/u/53684146?v=4" width=460 />|<img src="https://avatars.githubusercontent.com/u/43718982?v=4" width=460 />|<img src="https://avatars.githubusercontent.com/u/48307153?v=4" width=460>|<img src="https://user-images.githubusercontent.com/26710036/200534784-56842273-7428-4c6e-b79f-465027d4a5e7.png" width=460 />|
|INTJ<br>[@jinwoong](https://github.com/jinwoong16)|ISTP<br>[@wickedRun](https://github.com/wickedRun)|ISTP<br>[@sprituz](https://github.com/sprituz)|ENFJ<br>[@Jeonhui](https://github.com/Jeonhui)|ESFP<br>[@Max](https://github.com/boostcampwm-2022/iOS03-DailyQuest/wiki)|

# Notion 📕

[347km Notion 바로가기](https://boostcamp-wm.notion.site/iOS03-347km-b1040580dc7347b78b393b6761028ad2)
