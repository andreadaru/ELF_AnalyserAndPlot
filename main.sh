#!/bin/bash

#
# Main part of ELF_AnalyserAndPlot with welcome menu and the choice of complete analysis (diagonal.sh + grapher.sh)
# or only plot the results (grapher.sh)
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
echo ""
echo "         >>>  Welcome to ELF_AnalyserAndPlot-v1.0  <<<"
echo ""
echo " What do you want to do?"
echo "  1: Perform a complete ELF analysis of out' files"
echo "  2: Analysis results already exist thus only go to the plot part"
echo ""
echo "Press any other keys and enter to close"
read start

ini=`pwd`

if [ ${start} -eq 1 ]; then

  bash ${EAAPpath}/diagonal.sh
  echo "Analysis of out' files completed"
  bash ${EAAPpath}/grapher.sh

elif [ ${start} -eq 2 ]; then

# if the calculation exists (looking for folders) if not advise to take the option 1

  if [ -d results ] && [ -d tmp ] ; then
    bash ${EAAPpath}/grapher.sh
  else
    echo -e "
         \033[1mERROR!\033[0m You didn't perform an analysis or 
     any useful files don't exist so launch again and
                   \033[1mchoose the option 1\033[0m"


  fi

else

  clear

# signature and info

echo ""
echo -e "
         +------------------------------------------------------+
         |  ELF_AnalyserAndPlot  Copyright (C) 2016             |
         |  Author: \033[1mAndrea Darù\033[0m                                 |
         |  This program comes with ABSOLUTELY NO WARRANTY;     |
         |  In case of errors, questions or comments feel free  |
         |  to contact me! \033[1mandrea.daru.89@gmail.com\033[0m             |
         |  Thanks to use \033[1mELF_AnalyserAndPlot-v1.0\033[0m              |
         |                                                      |
         |       \033[1mIf you use this program please cite me\033[0m         |
         +------------------------------------------------------+"
echo ""

fi
