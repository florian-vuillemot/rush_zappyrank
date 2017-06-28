#!/bin/bash

#
# start.sh for zappyrank
#
# Made by jsx
# Login   <jean-sebastien.herbaux@epitech.eu>
#
# Started on  Sat Jun 24 2017 jsx
# Last update Sun Jun 25 2017 jsx
#

if [ $# -le 1 ]
then
    echo "Invalid number of args"
    exit
fi

echo "Starting... (" $(date) ")"
echo "Cleaning env..."

NAME=$1
TEAMS=${@:2}
BIN_ZAPPY="./zappy"
PREFIX="<zappyrank>"
RUNNER="runner.sh"
D_DIR_EXEC="/rendu/"
DIR_DELIVERY="./delivery"
D_IMAGE="epitechcontent/epitest-docker"
DIR_BUILD="./pools/$NAME"
DOCKER_RUN="sudo docker run --name $NAME -itd --storage-opt size=1G -v $PWD/$DIR_BUILD:$D_DIR_EXEC -w $D_DIR_EXEC $D_IMAGE /bin/bash 2> /dev/null"


dstartfclean() {
    sudo docker rm -f $NAME 2> /dev/null
    rm -f $DIR_BUILD/zappy
    rm -f $DIR_BUILD/runner.sh
}

checkRet(){
    if [ $1 -ne 0 ]
    then
        echo $2 ":" $3
        if [ $# -eq 4 ]
        then
            echo "$PREFIX: trying to fix it quickly, please wait..."
            eval $4 2> /dev/null
            if [ $? -ne 0 ]
            then
                echo "$PREFIX: Fix failed, please contact your system administrator"
                eval $FCLEAN
                exit
            else
                echo "$PREFIX: Fixed, continue..."
            fi
        else
            eval $FCLEAN
            exit
        fi
    fi
}

dstartfclean

mkdir $DIR_BUILD 2> /dev/null
checkRet $? "$PREFIX[$LINENO]: MKDIR " "Failed to create $DIR_BUILD directory" "rm -rf $DIR_BUILD && mkdir $DIR_BUILD"

cp $BIN_ZAPPY $DIR_BUILD
checkRet $? "$PREFIX[$LINENO]: CP " "Failed to copy $BIN_ZAPPY to $DIR_BUILD" "rm -rf $DIR_BUILD/$BIN_ZAPPY && cp $BIN_ZAPPY $DIR_BUILD"

cp $RUNNER $DIR_BUILD
checkRet $? "$PREFIX[$LINENO]: CP " "Failed to copy $RUNNER to $DIR_BUILD" "rm -rf $DIR_BUILD/$RUNNER && cp $RUNNER $DIR_BUILD"

for TEAM in $TEAMS
do
    echo "Retrieving folder for $TEAM"

    mkdir $DIR_BUILD/$TEAM 2> /dev/null
    checkRet $? "$PREFIX[$LINENO]: MKDIR " "Failed to create $DIR_BUILD/$TEAM directory" "rm -rf $DIR_BUILD/$TEAM && mkdir $DIR_BUILD/$TEAM"
    

    cp -rf $DIR_DELIVERY/$TEAM/* $DIR_BUILD/$TEAM/ 2> /dev/null
    checkRet $? "$PREFIX[$LINENO]: CP " "Failed to copy $TEAM in build dir ($DIR_BUILD)"
done

sudo docker run --name $NAME -itd -v $PWD/$DIR_BUILD:$D_DIR_EXEC -w $D_DIR_EXEC $D_IMAGE /bin/bash 2> /dev/null
sudo docker exec $NAME $D_DIR_EXEC/$RUNNER $NAME $TEAMS

dstartfclean