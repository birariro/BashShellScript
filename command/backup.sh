#!/bin/bash

if ! [ -d bak ]; then
        echo ">> [Create bak]"
        mkdir bak
fi

echo ">> [log file copy]"
cp *.log bak


#log 파일을 bak폴더에 백업을 하려고한다.
#[작업순서]
#1.bak 폴더가 있는지확인한다.
#2.폴더가 없다면 bak 폴더를 생성한다.
#3.확장자가 log 인 모든 파일을 bak폴더로 복사한다.