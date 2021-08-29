# R 스튜디오 인터페이스 이해하기
R 스튜디오를 실행시켰을 때 나타나는 화면은 <그림 1>과 같으며, 4개의 영역으로 구분됩니다. 실제 R 스튜디오를 사용하다 보면 화면 좌측에 위치한 Source 영역과 Console 영역을 주로 활용하게 됩니다. 필요에 따라 R 스튜디오의 도움을 받을 수 있는 영역은 오른쪽에 위치합니다. 이 외에도 각 영역에서 어떤 기능을 가지고 있는지 미리 알아두면 데이터 분석을 진 행할 때 R 스튜디오를 보다 편리하게 사용할 수 있습니다.  
![R 스튜디오 실행 화면](https://github.com/bjpublic/R_data/blob/main/%EC%9D%B4%EB%AF%B8%EC%A7%80/%5B%EA%B7%B8%EB%A6%BC%202-1%5D%20R%20%EC%8A%A4%ED%8A%9C%EB%94%94%EC%98%A4%20%EC%8B%A4%ED%96%89%20%ED%99%94%EB%A9%B4.PNG)

## Source 영역
Source 영역은 R 스튜디오 왼쪽 상단에 위치합니다. RGui를 실행시켰을 때 마주했 던 화면을 기억해보면 텍스트를 입력하는 곳과는 다른 속성의 영역입니다. RGui에서 텍스트를 입력하고 엔터를 치면 줄이 바뀌는 것이 아니라 한 줄의 명령을 실 행하게 됩니다.
동일한 프로세스를 이용하여 데이터 분석을 진행하더라도 한 줄로 데이터를 처리 하기는 쉽지 않습니다. R의 수많은 패키지와 기능을 활용하려면 여러 단계에 걸쳐서 함수와 패키지들을 활용해야 하기 때문에 한 줄마다 실행하는 것이 아니라 결 과가 나오기 전까지 자유롭게 수정할 수 있는 환경이 필요합니다.
이때 Source 영역에서 작성한 문서를 ‘스크립트’라고 부릅니다. 더 나아가 프로젝 트 혹은 팀 내에서 데이터 분석의 프로세스를 정립하여 자동화하는 과정에서도 스크립트를 작성하게 됩니다.  
![R 스튜디오 Source 영역](https://github.com/bjpublic/R_data/blob/main/%EC%9D%B4%EB%AF%B8%EC%A7%80/%5B%EA%B7%B8%EB%A6%BC%202-2%5D%20R%20%EC%8A%A4%ED%8A%9C%EB%94%94%EC%98%A4%20Source%20%EC%98%81%EC%97%AD.PNG)

## Console 영역
Console 영역은 Console, Terminal, Jobs 정보를 제공합니다. 각 정보를 어떻게 제 공하고 있는지 화면과 함께 미리 기억하는 것이 좋습니다.
* Console 창: RGui에서 작업한 환경과 동일하며 한 줄씩 입력할 때마다 결과가 출력됩니다. 스크립트를 활용하므로 일반적으로 Console 창에서 작업할 일은 없으나, 코드의 실행 결과 나 오류에 대한 정보가 나타나기 때문에 유용하게 활용할 수 있습니다.
* Terminal 창: 시스템에 내장되어 있는 셸을 이용해서 운영 체제(Operation System)를 조작
합니다.
* Jobs 창: 여러 R 스크립트를 동시에 처리하기 위해서 만들어진 기능입니다.  
![R 스튜디오 Console 영역](https://github.com/bjpublic/R_data/blob/main/%EC%9D%B4%EB%AF%B8%EC%A7%80/%5B%EA%B7%B8%EB%A6%BC%202-3%5D%20R%20%EC%8A%A4%ED%8A%9C%EB%94%94%EC%98%A4%20Console%20%EC%98%81%EC%97%AD.PNG)

## Environment/History/Connections/Tutorial 영역
R 스튜디오 오른쪽 위에 위치한 Environment / History / Connections / Tutorial 영 역은 탭으로 분리되어 있습니다.
* Environment 창: 분석 과정을 보여주는 기능을 하며, 불러온 데이터 및 가공하면서 생성한 다양한 객체, 함수 등이 어떤 것이 있는지 확인할 수 있습니다. ‘Environment is empty’라고 적혀 있으면 작업된 내용이 없어서 나타나는 초기 상태입니다.
* History 창: 지금까지 Console 창을 통해 실행된 코드들의 목록을 확인할 수 있는 곳입니다.
* Connection 창: MySQL, Oracle, MariaDB 등과 같은 관계형 데이터베이스 관리 시스템(Relational DataBase Management System)과 Spark에 손쉽게 연결할 수 있도록 제공하는 기능입니다.  
![R 스튜디오 Environment 영역](https://github.com/bjpublic/R_data/blob/main/%EC%9D%B4%EB%AF%B8%EC%A7%80/%5B%EA%B7%B8%EB%A6%BC%202-4%5D%20R%20%EC%8A%A4%ED%8A%9C%EB%94%94%EC%98%A4%20Environment%20%EC%98%81%EC%97%AD.PNG)

## Files/Plots/Packages/Help/Viewer 영역
R 스튜디오 오른쪽 아래에 위치한 Files / Plots / Packages / Help / Viewer 영역은 탭으로 분리되어 있습니다.
* Files 창: 현재 사용 중인 폴더를 보여줍니다. 데이터를 불러오거나 저장할 경우 해당 폴더를 먼저 참조하게 됩니다.
* Plots 창: 데이터를 분석하는 과정에서 기본적으로 내장되어 있는 시각화를 작성하거나 ggplot2와 같은 시각화 전문 패키지를 사용할 경우에 이 창에 표현됩니다.
* Packages 창: 현재 설치된 패키지 목록을 보여주고, 새로 패키지를 설치할 경우 혹은 기존에 존재하는 패키지를 삭제할 경우 마우스를 이용해서 쉽게 설치 및 제거가 가능합니다.
* Help 창: help( ) 함수나 ‘?’, ‘??’ 등을 활용하여 패키지에 대한 정보를 제공해줍니다. 도움말은 자세한 설명이 되어 있기에, 데이터 분석을 접근하는 분들이 R을 더욱 쉽게 이용할 수 있도록 한 기능입니다.
* Viewer 창: 분석 결과를 HTML과 같은 웹 형식 문서로 보여주는 창입니다. 일부 패키지의 경우 분석 결과를 웹 형식으로 제공하기도 하는데 이때 Viewer 창에 나타납니다.  
![R 스튜디오 Files 영역](https://github.com/bjpublic/R_data/blob/main/%EC%9D%B4%EB%AF%B8%EC%A7%80/%5B%EA%B7%B8%EB%A6%BC%202-5%5D%20R%20%EC%8A%A4%ED%8A%9C%EB%94%94%EC%98%A4%20Files%20%EC%98%81%EC%97%AD.PNG)
