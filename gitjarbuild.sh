#!/bin/bash

REPOSITORY=/home/developer/app  #프로젝트 디렉토리 주소이다.
PROJECT_NAME=server # 프로젝트 명
JAR_POSITION=$REPOSITORY/deploy #JAR 의 위치


if ! [ -d $REPOSITORY ]; then #해당 폴더가없다면 생성
	echo "Create dir "$REPOSITORY
	mkdir $REPOSITORY
	cd $REPOSITORY
		
fi


if ! [ -d $REPOSITORY/$PROJECT_NAME ]; then #해당 폴더가없다면 깃 클론
	echo "Create dir "$REPOSITORY"/"$PROJECT_NAME
	echo "### > [Git Clone]"
	cd $REPOSITORY
	git clone git project url
	cd $REPOSITORY/$PROJECT_NAME/ #위의 경로를 이용하여 프로젝트로 이동

else 
	cd $REPOSITORY/$PROJECT_NAME/ #프로젝트 파일이있다면 Pull
	echo "### > [Git Pull]"
	git pull #최신 마스터 브런치 받기
	
fi 



echo "### > [Bulid Start]"
chmod 700 gradlew
./gradlew clean build jar

echo "### > [Build Directory Move]"
cd $REPOSITORY

if ! [ -d $JAR_POSITION ] ;then # app/deploy 폴더가 있는지 확인하고 없다면 생성
	echo "Create dir /home/developer/app/deploy"
	mkdir $JAR_POSITION
fi

echo "### > [Build File Copy]"
cp $REPOSITORY/$PROJECT_NAME/build/libs/*.jar $JAR_POSITION

echo "### > [old Porject Working Check]"
CURRENT_PID=$(pgrep -f ${PROJECT_NAME}.*.jar) #같은 이름의 프로젝트가 샐행중인게 있는지 확인



if [ -z "$CURRENT_PID" ]; then
       echo "> Not running old Project."
else
                echo "### > [running old Project PID ] : " $CURRENT_PID
        echo "> Kill old Project"
        kill -15 $CURRENT_PID #실행중이였다면 예전 버전이니 종료
        sleep 5
fi
echo "### > [new Project start]"

JAR_NAME=$(ls -tr $JAR_POSITION |grep jar | tail -n 1) # 새로실행할 프로젝트 jar 을 찾는다 tail -n 으로 가장 나중에 생긴 jar로 찾는다

echo "### >[JAR NAME : ]"$JAR_NAME

cd $JAR_POSITION # jar 경로로 이동

java -jar $JAR_NAME --illegal-access=permit-Dspring.profiles.active=prod   2>&1& 

# nuhop 는 쉘스크립트 파일을 데몬 형태로 실행시키는 것으로 터미널이 끊겨도 실행가능하게한다. 즉 백그라운드 실행
# 2>&1 은 에러메시지를 화면에 출력하지말고 로그파일에 기록하라
# 0 표준입력 1 표준 출력 2 표준 에러
# 표준에러를 표준출력으로 돌리라는 의미이다 마지막 &는 백그라운드 실행

