![header](https://capsule-render.vercel.app/api?type=waving&height=250&color=gradient&reversal=true&fontAlignY=44&stroke=FFFFFF)
![img.png](resources/img.png)
# 🏡 개요
***

**“AI  거주지 평가 시스템”**

‘하우스코어(HOUSCORE)’는 공공 데이터를 활용한 AI 거주지 (건물) 평가 시스템으로 사용자에게 거주지에 대한 평가를 제공합니다.

공인중개사들의 설문을 바탕으로 건물 정보, 인프라 시설, 교통, 치안, 실거래가 공공 데이터를 수집하여 사용자에게 해당 거주지의 AI 점수를 제공, 선택에 도움이 될 수 있도록 합니다.

원하는 거주지의 주소를 입력 하고 해당 거주지의 상세 정보와 지표 정보를 검색해보세요. AI 점수를 통해 해당 거주지의 객관적인 지표를 확인하고 실거주자의 평가 점수와 리뷰를 비교해 거주지를 선택할 수 있습니다.


***
# 🏡 서비스 소개
***

| 메인 페이지 |주소 검색|리뷰 작성|리뷰 작성2|전체 리뷰 페이지| 
|:----:|:----:|:----:|:----:|:----:|
|![main](resources/메인화면.gif)|![search]((resources/주소검색.gif)|![review1](resources/리뷰작성.gif)|![review2](resources/리뷰작성2.gif)|![wholereview]|![search](resources/전체리뷰페이지.gif)|

### 메인 화면

![img.png](resources/메인화면.gif)

### 주소 검색

![img.png](resources/주소검색.gif)

### 리뷰 작성

![ezgif.com-video-to-gif-converter (2).gif](resources/리뷰작성.gif)
![ezgif.com-video-to-gif-converter (4).gif](resources/리뷰작성2.gif)


### 전체 리뷰 페이지

![ezgif.com-video-to-gif-converter (3).gif](resources/전체리뷰페이지.gif)

***
# 🏡 기술 스택
***
### 📱 Mobile
![](https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=Dart&logoColor=white) ![](https://img.shields.io/badge/Flutter%203.19.5-02569B?style=flat-square&logo=Flutter&logoColor=white)

### 🛢 Backend
![](https://img.shields.io/badge/JAVA%2017-2F2625?style=flat-square&logo=CoffeeScript&logoColor=white) ![](https://img.shields.io/badge/SpringBoot%203.2.4-6DB33F?style=flat-square&logo=SpringBoot&logoColor=white)
![](https://img.shields.io/badge/FastAPI%2017-009688?style=flat-square&logo=fastapi&logoColor=white)

### 🤖 AI
![](https://img.shields.io/badge/Python%203.11-3776AB?style=flat-square&logo=Python&logoColor=white)
![](https://img.shields.io/badge/Pandas%202.1.4-150458?style=flat-square&logo=pandas&logoColor=white)
![](https://img.shields.io/badge/Pycarot%203.3.1-00B0D8?style=flat-square&logo=&logoColor=white)
![](https://img.shields.io/badge/scikitlearn%201.4.2-F7931E?style=flat-square&logo=scikit-learn&logoColor=white)
![](https://img.shields.io/badge/xgboost%202.0.3-F7901E?style=flat-square&logo=&logoColor=white)
![](https://img.shields.io/badge/lightgbm%204.3.0-57182D?style=flat-square&logo=&logoColor=white)

### 💾 Database
![](https://img.shields.io/badge/MongoDB-47A248?style=flat-square&logo=MongoDB&logoColor=white)
![](https://img.shields.io/badge/PostgreSQL%2016.2-4169E1?style=flat-square&logo=postgresql&logoColor=white)
### 🛠 Infra/CI
![](https://img.shields.io/badge/Nginx-009639?style=flat-square&logo=nginx&logoColor=white)
![](https://img.shields.io/badge/Amazon%20EC2-FF9900?style=flat-square&logo=AmazonEC2&logoColor=white)
![](https://img.shields.io/badge/Docker%2025.0.4-2496ED?style=flat-square&logo=Docker&logoColor=white)
![](https://img.shields.io/badge/Jenkins-D24939?style=flat-square&logo=Jenkins&logoColor=white)
![](https://img.shields.io/badge/Sonatype%20Nexus%20Repository-1B1C30?style=flat-square&logo=Sonatype&logoColor=white)
![](https://img.shields.io/badge/SonarQube-4E9BCD?style=flat-square&logo=SonarQube&logoColor=white)
![](https://img.shields.io/badge/Portainer-13BEF9?style=flat-square&logo=portainer&logoColor=white)
### 📅 Collaboration Tools
![](https://img.shields.io/badge/GitLab-FC6D26?style=flat-square&logo=Gitlab&logoColor=white)
![](https://img.shields.io/badge/Jira-0052CC?style=flat-square&logo=Jira&logoColor=white) ![](https://img.shields.io/badge/Figma-F24E1E?style=flat-square&logo=Figma&logoColor=white)
![](https://img.shields.io/badge/Notion-000000?style=flat-square&logo=notion&logoColor=white)
![](https://img.shields.io/badge/Gerrit-EEEEEE?style=flat-square&logo=gerrit&logoColor=black)
![](https://img.shields.io/badge/MatterMost-0058CC?style=flat-square&logo=mattermost&logoColor=white)


***
# 🏡 기술 아키텍쳐
***

![Frame 37 (4).png](resources/아키텍쳐.png)

***
# 🏡 AI
***
### 활용 공공데이터 구성
![gonggongdata.png](resources/gonggongdata.png)

![score_data.png](resources/score_data.png)
- 집품으로부터 제공받은 25,000건의 건물별 거주자 리뷰 평점 데이터와 공공데이터를 활용하여 리뷰가 없는 건물에 대해 예상 평점을 예측하는 모델을 만들고자 함
- 위와 같이 범위를 지정하여 라벨링을 진행한 결과 클래스별 데이터 불균형 존재
- pycaret automl을 사용하여 **classfication** 시도 <br/>
  ![automl.png](resources/automl.png)
- 상위 모델 중 ligthtgbm, rf, xgboost를 채택하여 클래스별 데이터 불균형이 존재했기 때문에 SMOTE 기법을 활용하여 train 데이터셋에 대해 오버샘플링 진행
  - 각 모델 별 하이퍼파라미터 튜닝 후 Accuracy, AUC <br/>
    ![modeling.png](resources/modeling.png)<br/>
  - 성능이 가장 좋은 **RandomForest 모델** 채택
  
###  SMOTE → StandardScaler → RandomForestClassifier
![rf_result.png](resources/rf_result.png)<br/>
기본 모델 **Accuracy : 44.9%**, **AUC: 0.66** <br/>
하이퍼파라미터 튜닝 후 **Accuracy : 45.4%**, **AUC: 0.66** <br/>
10번의 k-fold 교차검증 진행 **Accuracy : 42.5%**, **AUC: 0.66** <br/>
### 변수 중요도
![rf_importance.png](resources/rf_importance.png)<br/>
### 혼동행렬
![rf_confusion_matrix.png](resources/rf_confusion_matrix.png)<br/>

***
# 🏡 팀 소개
***

### 👑 박영규
- 팀장(PM), 발표
- Backend Springboot OAuth2 소셜로그인, JWT, S3 연결, Mainpage API 개발
- Infra 및 CI/CD 전반

### 🐲 안상준
- Mobile 팀원, 서기, 노션 관리, 멘토링 보고
- 메인 페이지, 거주지 관련 컴포넌트, 디자인

### 🐑희태
- Mobile 리더
- 프로젝트 구조 설계, 코드 제네레이션, 페이지네이션 상태관리, 인증 처리, 디자인

### 🏊‍ 천우진
- Mobile, 멘토링 보고
- 리뷰 CRUD 페이지 및 기능 구현

### 🧗‍ 정종욱
- 인프라 데이터 전처리,AI
- UCC 담당

### 🐶 김희주
- Backend 리더
- 건물 정보 Batch, 거주지 관련 조회 API, 리뷰 CRUD, 관심지역 CRUD

### 🐻 안성재
- AI 리더, 서기, 멘토링 보고
- 공공데이터 수집/전처리/적재, AI, fastapi 서버 구현 및 연결



### 👥 팀 관리
- `Jira`를 이용한 일정 관리
- **총 784개의 이슈**

![img.png](resources/img2.png)

- `Gerrit`을 이용한 코드 리뷰

![img_1.png](resources/img_1.png)

***
# 🏡 관련 문서
***

## ![](https://img.shields.io/badge/-000000?style=flat-square&logo=notion&logoColor=white) [Team Notion](https://faceted-scallion-14e.notion.site/HOUSCORE-248c8513604545e6af56f22a9d82c0e9?pvs=4)

## [프로젝트 소개 PPT](https://www.miricanvas.com/v/137to7g)

![](https://capsule-render.vercel.app/api?type=slice&height=250&color=gradient&text=넥카라쿠배&fontAlign=15&textBg=false&fontSize=30&reversal=false&fontAlignY=50&animation=twinkling&fontColor=FFFFFF&section=footer&desc=박영규%20김희주%20안성재%20천우진%20안상준%20양희태%20정종욱&descAlignY=85)
