#!/data/data/com.termux/files/usr/bin/sh
#Author: l0gg3r
#Source: https://github.com/damian1421/bkp

#Script to pull/push files/folders across devices
help(){
	echo ${LBLUEE}[HELP]
	echo Fast-Mode Usage: ./bkp_l0gg3r.sh source-file-or-folder destination-file-or-folder
	echo Normal-Mode Usage: ./bkp_l0gg3r.sh
	${NC}
}

#Define colors
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BROWN='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LGREY='\033[0;37m'
DGREY='\033[1;30m'
LRED='\033[1;31m'
LGREEN='\033[1;32m'
YELLOW='\033[1;33m'
LBLUE='\033[1;34m'
LPURPLE='\033[1;35m'
LCYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m' #No color

if [ "$1" != "" ]
then
	if=$1
fi
if [ "$2" != "" ]
then
	of=$2
fi
#Shows defined variables
Checklist()
{
clear
var=$if
Status
echo ${LBLUE}"Input File: ${LGREEN}$var"${NC}
var=$touser
Status
echo ${LBLUE}"TO User: ${LGREEN}$var"${NC}
var=$toip
Status
echo ${LBLUE}"TO IP: ${LGREEN}$var"${NC}
var=$of
Status
echo ${LBLUE}"Output File: ${LGREEN}$var"${NC}
echo ""
}

#Verify if selected variable is defined.
Status()
{
if [ -z $var ] ; then
	echo -n "${RED}[NG]${NC} "
else
	echo -n "${GREEN}[OK]${NC} "
fi
}

Checklist

#Write path of SOURCE file/folder
echo ${DGREY}[TERMUX] /data/data/com.termux/files/home
echo [DESKTOP] /home/$(whoami)${LBLUE}
echo ""
echo -n "Insert (from) file: "${LGREEN}
read if
Checklist

#Write destination USER
echo  -n ${LBLUE}"Insert (to) USER: "${LGREEN}
read touser
Checklist

#Write IP to send files
echo -n ${LBLUE}"Insert (to) IP: "${LGREEN}
read toip
Checklist

#Write path of DESTINATION file/folder
echo ${DGREY}[TERMUX] /data/data/com.termux/files/home
echo [DESKTOP] /home/$touser${NC}
echo ""
echo -n ${LBLUE}"Insert (to) folder: "${LGREEN}
read of
Checklist
echo ${LBLUE}"Moving the Earth to the right place & setting up terminal"
termux-wake-lock
echo ""
echo "I'm going to copy:"
echo ${LGREEN}"$if >> $touser@$toip:$of"${LBLUE}
sleep 2
clear
method(){
echo "Choose backup method: "
echo "[1] rsync"
echo "[2] scp"
echo ""
echo -n "Write a number from the list: "${LGREEN}
read mode
}
case $mode in
1)
	clear
	echo ${LBLUE}"Selected: ${LGREEN}rsync"${NC}
	clear
	rsync -rtv -e "ssh -p 8022" $if $touser@$toip:$of
	var=$?
	;;
2)
	clear
	echo ${LBLUE}"Selected: ${LGREEN}scp"${NC}
	clear
	scp -r -P 8022 $if $touser@$toip:$of
	var=$?
	;;
*)
	echo ${YELLOW}"Please write the number of your choice & press ENTER"${LBLUE}
	echo ""
	method
	;;
esac

if [ var != 0 ] ; then
	echo -n "${RED}[NG] Finished ${NC} "
else
	echo -n "${GREEN}[OK] Finished ${NC} "
fi
termux-vibrate
termux-toast "Respaldo finalizado"
termux-wake-unlock
exit 0
