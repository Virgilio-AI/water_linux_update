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



# https://raw.githubusercontent.com/Virgilio-AI/dotFiles-AW/master/version.txt


function CheckNewUpdate()
{
	mkdir -p /tmp/water_linux
	cd /tmp/water_linux
	wget https://raw.githubusercontent.com/Virgilio-AI/dotFiles-AW/master/version.txt
	# if they are different return no errors so that means there is an update
	cmp  --silent /tmp/water_linux/version.txt version.txt || return 0
	# else there is no update and you return errors
	return 1
}

function SyncFolders()
{

}
function update()
{
	# create the directory
	mkdir /tmp/water_linux
	# cd into the folder
	cd /tmp/water_linux
	# git clone the dotFiles
	git clone https://github.com/Virgilio-AI/dotFiles-AW.git
	# create the local Folder directory
	mkdir localDotFiles
	# pours all the local changes to the directory
	poour.zsh /home/$username localDotFiles
	# get a basic diff to see what is going to change
	diff -bur localDotFiles/ dotFiles-AW/
	# echo the confirmation
	echo "deseas continuar con la actualizacion?(Y,n)"
	read ans
	# use () instead of [[]] for some examples
	if [[ ans == "y" || ans == "Y" || ans == "" ]]
	then
		SyncFolders
	fi
}



function askForConfirmation()
{
	echo "there is an update available"
	echo "update?(Y/n)"
	read ans
	# use () instead of [[]] for some examples
	if [[ ans == "y" || ans == "Y" || ans == "" ]]
	then
		update
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
