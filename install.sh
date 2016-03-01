#!/bin/bash

#
# simple installer of ELF_AnalyserAndPlot that will create an alias and an exported variable into .bashrc
#

# LICENSE
#
#    This file is part of ELF_AnalyserAndPlot Copyright (C) 2016  Andrea Darù
#
#    ELF_AnalyserAndPlot is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    ELF_AnalyserAndPlot is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#



clear
echo "
         >>>  Welcome to ELF_AnalyserAndPlot-v1.0 installer <<<
"

echo "Tell me a path to install or \"enter\" to install it in ${HOME}"
read main
    if [ -z ${main} ]; then
    main=$HOME
    else
        until [ -e ${main} ]; do     # control of the wrong path
        echo "The inserted path doesn't exist, give me it again!"
        read main
            if [ -z ${main} ]; then  # pressing enter so the $HOME path will be set
            main=$HOME
            fi
            if [ -n "${main}" ]; then  # if a different path is chosed
            main=${main}
            fi
        done
    fi

echo -e "Installation in ${main}"

mkdir ${main}/ELF_AnalyserAndPlot

ppath="${main}/ELF_AnalyserAndPlot"    # installation path

# list of scripts to be copied

cp main.sh ${ppath}
cp diagonal.sh ${ppath}
cp calc.py ${ppath}
cp grapher.sh ${ppath}
cp div.py ${ppath}

# creation of the conf.log file (it could be usefull with future version or with updates)
# it contains some information about: version, directory and machine

echo -e "# version
1.0

# path of the scripts
${ppath}
" > ${main}/ELF_AnalyserAndPlot/conf.log
echo "# About the machine" >> ${main}/ELF_AnalyserAndPlot/conf.log
lsb_release -idrc >> ${main}/ELF_AnalyserAndPlot/conf.log
ker=`uname -mrs`
echo "Kernel:	${ker}" >> ${main}/ELF_AnalyserAndPlot/conf.log
echo "" >> ${main}/ELF_AnalyserAndPlot/conf.log
echo "# About installed repositories" >> ${main}/ELF_AnalyserAndPlot/conf.log
sed --version | sed -n "1 p" >> ${main}/ELF_AnalyserAndPlot/conf.log
awk --version | sed -n "1 p" >> ${main}/ELF_AnalyserAndPlot/conf.log
python --version >> ${main}/ELF_AnalyserAndPlot/conf.log 2>&1
gnuplot --version >> ${main}/ELF_AnalyserAndPlot/conf.log

# set up the alias in .bashrc

echo ""
echo "Give me an alias to set it up on .bashrc"
        while [ -z ${al} ]; do     # control of the path if only enter recall for the alias
        echo "Type an alias"
        read al
        done
echo "alias ${al}='bash ${ppath}/main.sh'
export EAAPpath=${ppath}" >> ~/.bashrc

source ~/.bashrc

echo ""
echo -e " - Done -"
echo ""
clear
echo -e "
                 \033[1mELF_AnalyserAndPlot v1.0 installed successfully\033[0m

            This program is free software, distributes under the terms 
             of the GNU General Public License v3 Copyright (C) 2016

            Author: \033[1mAndrea Darù\033[0m
            This program comes with ABSOLUTELY NO WARRANTY;
            In case of errors, questions or comments feel free
            to contact me! \033[1mandrea.daru.89@gmail.com\033[0m

                     \033[1mIf you use this program please cite me!\033[0m

                          Enjoy ELF_AnalyserAndPlot! ;)
        Go into the folder that contains the out-files of ELF calculation
         open a terminal and test it using the setted up alias: ${al}"

exit

