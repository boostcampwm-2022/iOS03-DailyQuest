# Daily Quest ๐งฉ

![Group_36](https://user-images.githubusercontent.com/26710036/207524292-bf21d9d8-7738-4ea2-9bab-db4f513d5a71.png)

<a href="https://apps.apple.com/kr/app/apple-store/id6444737672"><img src="https://user-images.githubusercontent.com/53684146/209014894-ec8d5bba-8282-4410-ac29-ffcb3863ddb9.png"/></a>

์์ง ๋ง์์ผ ํ  ํ๋ฃจ์ ํ์คํธ, Daily Quest์ ํจ๊ป  ๐งฉ


# Features ๐

<table width="100%">
    <tr>
      <td width="25%" align="center">๐ ๋ฌ์ฑํ๊ณ ์ ํ๋ ํ์คํธ๋ค์ ๋ฑ๋กํด๋ณด์ธ์!</td>
      <td width="25%" align="center">โ ์บ๋ฆฐ๋๋ฅผ ํตํด ํ์คํธ๋ฅผ ํ์ธํ  ์ ์์ต๋๋ค!</td>
      <td width="25%" align="center">๐ ๋ค๋ฅธ ์ฌ๋๋ค์ ํ์คํธ๋ค์ ๋๋ฌ๋ณด์ธ์!</td>
      <td width="25%"  align="center">๐คผโโ๏ธ ๋ค๋ฅธ ์ฌ๋์ ์ ์ฒด ํ์คํธ๋ ํ์ธํ  ์ ์์ด์!</td>
    </tr>
    <tr>
      <td width="25%"  align="center"><img src="https://user-images.githubusercontent.com/26710036/207527078-4bebd25f-1337-4dff-911e-45d9e2362fa1.gif" /></td>
      <td width="25%"  align="center"><img src="https://user-images.githubusercontent.com/26710036/207528844-964cf81e-0597-4a67-826d-625dd51de6f4.gif" /></td>
      <td width="25%"  align="center"><img src="https://user-images.githubusercontent.com/26710036/207528731-8b6bea5b-4a60-414e-9b63-921b36bde368.gif" /></td>
      <td width="25%"  align="center"><img src="https://user-images.githubusercontent.com/26710036/207528793-a67e4940-607c-48ab-8937-ef9240e7ab7a.gif" /></td>
    </tr>
</table>



# Stacks ๐งโ๐ป

## MVVM-C & Clean Architecture

![Frame 9](https://user-images.githubusercontent.com/26710036/207525159-3629e537-5270-4b48-b60f-158525a9a333.png)

- ์ดํ์ ๊ธฐํํ๋ฉด์ ํ๊ณณ์์ ๋ค๋ฅธ ์ฌ๋ฌ๊ณณ์ผ๋ก ์ด๋ํ  ์ ์๋ View๊ฐ ์๊ฒผ๊ณ , ํ๋ฉด์ ์ ํํ๋ ์ญํ ์ ํด๋น ViewController๊ฐ ์ฒ๋ฆฌํ๋ฉด, ์ฝ๋๋์ด ๊ธธ์ด์ ธ ๊ฐ๋์ฑ์ด ๋จ์ด์ง๊ณ , ์ญํ ๊ณผ ์ฑ์์ ๋ํด ์๊ฐํด๋ณด์์ผํ  ํ์๊ฐ ์๋ค๋ ํ๋จํ์ Coordinator๋ฅผ ๋์ํ์์ต๋๋ค.
- ์์กด์ฑ ์ฃผ์๊ณผ ๊ด๋ จ๋ ๋ถ๋ถ์ DI ์ปจํ์ด๋๋ฅผ ํตํด ์งํํ๋ฉด์ ๊ฐ ViewController๋ค์ ์ด์ ํด๋นํ๋ ์ญํ ๊ณผ ์ฑ์์์ ์์ ๋กญ๊ฒ ํ  ์ ์์์ต๋๋ค.
- ์ํํ ํ๋ก์ ํธ ์งํ์ ํ๋๋ฐ ์์ด์ 6์ฃผ๋ผ๋ ๊ธฐ๊ฐ์ ํจ์จ์ ์ผ๋ก ์ฌ์ฉํ์ฌ ๊ฐ๋ฐํ  ์ ์๋ ๋ฐฉ๋ฒ์ด๋ผ ์๊ฐํ๊ณ  ์ฑํํ์์ต๋๋ค.
- ๊ฐ ๋ ์ด์ด๋ณ๋ก ๊ฐ๋ฐ์ ์งํํ  ๋, ๋ค๋ฅธ ๋ ์ด์ด์ ์ถ์ํ๋ ์ธํฐํ์ด์ค๋ง ์๊ฐํ๊ณ  ๊ฐ๋ฐํ์์ต๋๋ค.
- ๋ ์ด์ด๋ณ๋ก ๋ถ๋ฆฌ๊ฐ ๋์๊ธฐ์ ํ์คํธ ์ฝ๋ ์์ฑ์ด ์ฉ์ดํด์ก์ต๋๋ค.

## RxSwift

- MVVM ํจํด์ ์ฌ์ฉํจ์ ๋ฐ๋ผ, ๋ฐ์ดํฐ ๋ฐ์ธ๋ฉ ๋ฐฉ์์ Combine, RxSwift, ๊ทธ๋ฆฌ๊ณ  ์์ฒด ๊ตฌํ์ผ๋ก ์ฒ๋ฆฌํ  ํ์๊ฐ ์์ด์ ๋ง์ ๊ณณ์์ ์ฌ์ฉ์ค์ธ RxSwift๋ฅผ ์ฑํํ์์ต๋๋ค.
- Firebase์์ ๋น๋๊ธฐ๋ก ๋ฐ๋ ๋ฐ์ดํฐ๋ค์ ํด๋ก์ ๊ฐ ์๋ return ํ์์ผ๋ก ๋ฐ์์ ๊ฐ๋จํ๊ฒ ์ฒ๋ฆฌํ๊ณ , ์๋ฌ๋ ์ฝ๊ฒ ์ฒ๋ฆฌํ๊ธฐ ์ํด์ ์ฑํํ์์ต๋๋ค.

## Firebase & Realm

- ํ์คํธ๋ค์ ๋ฐ์ดํฐ๋ก ์ ์ฅํ๋ ๋ฐ์ ์์ด **์์ ์ฑ**์ ๋ํด์ฃผ๊ธฐ ์ํด **์๋ฒ ๋ฐ์ดํฐ ๋ฒ ์ด์ค(Firebase)**์ **๋ก์ปฌ ๋ฐ์ดํฐ ๋ฒ ์ด์ค(Realm)**๋ฅผ ์ฌ์ฉํ์์ต๋๋ค.
- **๋ค์ํ ๊ธฐ์  ์คํ**์ ์ด์ฉํด๋ณด๋ ๊ฒ์ ์ด๋ฒ ํ๋ก์ ํธ์ ๋ชฉํ๋ก ์ก์๊ณ , ์ ํ์ด ์ง์ํด์ฃผ๋ ๋ผ์ด๋ธ๋ฌ๋ฆฌ๊ฐ ์๋ ์ธ๋ถ์ ๋ผ์ด๋ธ๋ฌ๋ฆฌ๋ฅผ ์ ํํด๋ณด๊ธฐ๋กํ์ฌ **Realm**์ ์ฑํํ๊ฒ ๋์์ต๋๋ค.

![Frame 10](https://user-images.githubusercontent.com/26710036/207525512-01ef9e47-409c-4e59-b78d-948ace96f7ae.png)

- 6์ฃผ๋ผ๋ ์งง์ ๊ฐ๋ฐ ๊ธฐ๊ฐ ๋์ ํ๋ก์ ํธ๋ฅผ ๊ตฌํํ๊ธฐ ์ํด ์๋ฒ ๊ตฌ์ถ์ด ์๋ **์์ฝ๊ฒ ์ฌ์ฉ**ํ  ์ ์๋ **Firebase**๋ฅผ ์ฑํํ์์ต๋๋ค.
    
![Untitled 3](https://user-images.githubusercontent.com/26710036/207525678-40517feb-aefc-419c-a933-5a8a5414859e.png)    

# Design ๐๏ธ

- ๊ฐ๋ฐ์ ์งํํ๊ธฐ์ ์์ ํผ๊ทธ๋ง๋ฅผ ํตํด ํ๋ก์ ํธ์ ๋ ์ด์์์ ๊ตฌ์ฑํ์ฌ ๊ตฌ์ฒดํํ์์ต๋๋ค.
- Daily Quest์ ๋ฉ์ธ ์บ๋ฆญํฐ์ธ ๋งฅ์ค๋ฅผ ๋์์ธํ์ฌ Daily Quest๋ง์ ์์ด๋ดํฐํฐ๋ฅผ ๋ถ์ฌํ์์ต๋๋ค.

<img width="689" alt="%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-12-02_18 19 22" src="https://user-images.githubusercontent.com/26710036/207525776-a83b63e2-43a2-4be1-a499-e92d8d264560.png">

# Team ๐ฅ

|S014_๊น์ง์|S017_๋ฐ๋ํ|S036_์ด๋ค์ฐ|S042_์ด์ ํฌ|S000_๋งฅ์ค|
|:-:|:-:|:-:|:-:|:-:|
|<img src="https://avatars.githubusercontent.com/u/26710036?v=4" width=460 />|<img src="https://avatars.githubusercontent.com/u/53684146?v=4" width=460 />|<img src="https://avatars.githubusercontent.com/u/43718982?v=4" width=460 />|<img src="https://avatars.githubusercontent.com/u/48307153?v=4" width=460>|<img src="https://user-images.githubusercontent.com/26710036/200534784-56842273-7428-4c6e-b79f-465027d4a5e7.png" width=460 />|
|INTJ<br>[@jinwoong](https://github.com/jinwoong16)|ISTP<br>[@wickedRun](https://github.com/wickedRun)|ISTP<br>[@sprituz](https://github.com/sprituz)|ENFJ<br>[@Jeonhui](https://github.com/Jeonhui)|ESFP<br>[@Max](https://github.com/boostcampwm-2022/iOS03-DailyQuest/wiki)|

# Notion ๐

[347km Notion ๋ฐ๋ก๊ฐ๊ธฐ](https://boostcamp-wm.notion.site/iOS03-347km-b1040580dc7347b78b393b6761028ad2)
