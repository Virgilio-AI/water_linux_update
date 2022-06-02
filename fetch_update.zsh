#!/usr/bin/zsh
###############################
# Author: Virgilio Murillo Ochoa
# Date: 01/June/2022 - Wednesday
# personal github: Virgilio-AI
# linkedin: https://www.linkedin.com/in/virgilio-murillo-ochoa-b29b59203
# contact: virgiliomurilloochoa1@gmail.com
# web: virgiliomurillo.com
# #########################################


# usage
# fetch_update.zsh [username]
# This is a basic script to fetch an update from the main repo

username=$1

# use () instead of [[]] for some examples
if [[ $username == "" ]]
then
	username=$(whoami)
fi

# create the log file
mkdir -p /tmp/water_linux/Log
touch /tmp/water_linux/Log/update.txt



# https://raw.githubusercontent.com/Virgilio-AI/dotFiles-AW/master/version.txt

function SyncFolder()
{
	src=$1
	target=$2
	mkdir -p ${target::-1}

	if [[ -d ${src::-1} ]]
	then
		rsync -aAXv $src $target
	fi
}


function CheckNewUpdate()
{
	mkdir -p /tmp/water_linux |& tee -a /tmp/water_linux/Log/update.txt
	cd /tmp/water_linux |& tee -a /tmp/water_linux/Log/update.txt
	wget https://raw.githubusercontent.com/Virgilio-AI/dotFiles-AW/master/version.txt |& tee -a /tmp/water_linux/Log/update.txt
	# if they are different return no errors so that means there is an update
	cmp  --silent /etc/water_linux/version.txt version.txt  || return 0
	# else there is no update and you return errors
	echo "no updates available" |& tee -a /tmp/water_linux/Log/update.txt
	return 1
}

function SyncFolders()
{
	# update folder Example:
	# /home/user/folder
	# homeFolder Example:
	# /home/user

	updateFolder=$1
	homeFolder=$2
	rsync -aAXv --exclude=personal  --exclude=UltiSnips --exclude=Plugins --exclude=.vimdata $updateFolder/.config/nvim/ $homeFolder/.config/nvim/ |& tee -a /tmp/water_linux/Log/pour.txt

	#
	### the next ones we can use the function
	#

	# awesome:
	SyncFolder $updateFolder/.config/awesome/ $homeFolder/.config/awesome/
	# mpd:
	SyncFolder $updateFolder/.config/mpd/ $homeFolder/.config/mpd/
	# ncmpcpp:
	SyncFolder $updateFolder/.config/ncmpcpp/ $homeFolder/.config/ncmpcpp/
	# neofetch:
	SyncFolder $updateFolder/.config/neofetch/ $homeFolder/.config/neofetch/
	# ranger:
	SyncFolder $updateFolder/.config/ranger/ $homeFolder/.config/ranger/
	# zsh:
	SyncFolder $updateFolder/.config/zsh/ $homeFolder/.config/zsh/

	# ==========================
	# ========== sync the .local files ======
	# ==========================

	# bin:
	SyncFolder $updateFolder/.local/bin/ $homeFolder/.local/bin/
	# etc:
	SyncFolder $updateFolder/.local/etc/ $homeFolder/.local/etc/
	# lib:

	# suckless files
	# dwm:
	SyncFolder $updateFolder/.local/src/dwm/ $homeFolder/.local/src/dwm/
	# dwmblocks:
	SyncFolder $updateFolder/.local/src/dwmblocks/ $homeFolder/.local/src/dwmblocks/
	# dmenu:
	SyncFolder $updateFolder/.local/src/dmenu/ $homeFolder/.local/src/dmenu/
	# awesome:
	SyncFolder $updateFolder/.local/src/awesome/ $homeFolder/.local/src/awesome/
	# st:
	SyncFolder $updateFolder/.local/src/st/ $homeFolder/.local/src/st/

}
function update()
{
	# create the directory
	mkdir /tmp/water_linux
	# cd into the folder
	cd /tmp/water_linux
	# remove the previous folders
	rm -rfd /tmp/water_linux/localDotFiles
	rm -rfd /tmp/water_linux/dotFiles-AW.git

	# git clone the dotFiles
	git clone https://github.com/Virgilio-AI/dotFiles-AW.git
	# create the local Folder directory
	mkdir localDotFiles
	# pours all the local changes to the directory
	pour.zsh /home/$username localDotFiles

	# remove ineccesary files in dotFiles-AW
	rm -rfd dotFiles-AW/.git
	rm dotFiles-AW/.gitignore
	rm dotFiles-AW/.gitmodules
	rm dotFiles-AW/README.md
	rm dotFiles-AW/version.txt
	rm dotFiles-AW/.config/nvim/.netrwhist
	rm -rfd dotFiles-AW/.config/nvim/UltiSnips
	rm -rfd dotFiles-AW/images
	rm README.md

	# remove innecesary files in localDotFiles
	rm localDotFiles/.config/mpd/pid
	rm localDotFiles/.config/mpd/log
	rm localDotFiles/.config/nvim/PlugIns


	# get a basic diff to see what is going to change
	diff -bur localDotFiles/ dotFiles-AW/ > diff.txt
	# check the diff of the update
	nvim diff.txt
	# echo the confirmation
	echo "puedes hacer la actualizacion de forma manual. los archivos estan en /tmp/water_linux/dotFiles-AW"
	echo "deseas continuar con la actualizacion automatica?(Y,n)"
	read ans
	# use () instead of [[]] for some examples
	if [[ $ans == "y" || $ans == "Y" || $ans == "" ]]
	then
		SyncFolders /tmp/water_linux/dotFiles-AW /home/rockhight && 
		echo "la actualizacion se ah echo de forma correcta"
	fi
}



function askForConfirmation()
{
	echo "there is an update available" |& tee -a /tmp/water_linux/Log/update.txt
	echo "update?(Y/n)" |& tee -a /tmp/water_linux/Log/update.txt
	read ans |& tee -a /tmp/water_linux/Log/update.txt
	# use () instead of [[]] for some examples
	if [[ $ans == "y" || $ans == "Y" || $ans == "" ]]
	then
		update |& tee -a /tmp/water_linux/Log/update.txt
	fi
}

# ---------------------------------------------------------------
# ==========================
# ========== here starts the actua script ======
# ==========================



# use () instead of [[]] for some examples
# 0 is true, 1 is false
if [[ CheckNewUpdate ]]
then
	# here you will be asked if you want to be hearing updates
	# if you want to update or you want to do a partial update
	# partial updates are currently not supported
	if [[ askForConfirmation ]]
	then
		update
	fi
fi
