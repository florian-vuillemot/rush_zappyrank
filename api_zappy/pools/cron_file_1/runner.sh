#!/bin/bash

#
# runner.sh for zappyrank
#
# Made by jsx
# Login   <jean-sebastien.herbaux@epitech.eu>
#
# Started on  Sat Jun 24 2017 jsx
# Last update Sun Jun 25 2017 jsx
#

BIN_ZAPPY="./zappy"
NAME=$1
TEAMS=${@:2}
N_ZIP="zappy_ai.zip"
MNT_DIR="/rendu"
TMP_DIR="/tmp/"
TIMEOUT="60"

cp -r $MNT_DIR $TMP_DIR
cd $TMP_DIR/$MNT_DIR

unpackTeam() {
    # TRY TO UNZIP
    unzip $1/$N_ZIP -d $1/ 2> /dev/null
    rm -f $1/$N_ZIP 2> /dev/null

    # TRY TO MAKE RE
    make re -C $1/ 2> /dev/null
}

echo "Evaluating the pool... (" $(date) ")"
for TEAM in $TEAMS
do
    echo "Unpacking AI for $TEAM"
    unpackTeam $TEAM
    echo "Done"
done


./zappy -p 4242 -n $TEAMS -t $TIMEOUT > $MNT_DIR/$NAME.log &
sleep 1
for TEAM in $TEAMS
do
    echo "Starting AI for $TEAM"
    LOGFILE=$(echo "$MNT_DIR/log-$TEAM.txt")
    cd $TMP_DIR/$MNT_DIR/$TEAM && timeout 61 ./zappy_ai -h 127.0.0.1 -p 4242 -n $TEAM &> $LOGFILE &
    cd $TMP_DIR/$MNT_DIR
done
