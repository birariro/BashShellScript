#! /bin/bash


IMAGE_NAME=scimage
CONTAINER_NAME=scctn


if (( $EUID != 0 )); then
    echo "Shell Run as Root"
    exit
fi


if [ -z $1 ] ; then
        echo input -i      : docker file build
        echo input -c      : Container Create
        echo input -e      : Container Connenction
        echo input -ik     : remove Image
        echo input -ck     : remove Container
        echo input -l      : Container Logs
        echo input -m      : Container Monitoring
elif [ $1 == "-i" ] ; then
        docker build -t $IMAGE_NAME .

elif [ $1 == "-c" ] ; then
        docker run -it --restart=always -p 80:80 -v /tmp/target:/home/app/deploy --name $CONTAINER_NAME $IMAGE_NAME bash

elif [ $1 == "-e" ] ; then
        docker exec -it $CONTAINER_NAME bash

elif [ $1 == "-ck" ] ; then
        docker stop $CONTAINER_NAME
        docker rm $CONTAINER_NAME

elif [ $1 == "-ik" ] ; then
        docker rmi $IMAGE_NAME

elif [ $1 == "-l" ] ; then
        docker logs $CONTAINER_NAME

elif [ $1 == "-m" ] ; then
        docker stats $CONTAINER_NAME

fi
