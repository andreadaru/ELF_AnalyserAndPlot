#!/bin/bash

# graph part of ELF_AnalyserAndPlot with 2 different kind of elaboration: 
#  - sum multiple basins around an atom 
#  - multiple basin dividing (still experimental but very precise)
# or no elaboration

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



ini=`pwd`
tmp="${ini}/tmp"

# original files in .../originals and later every elaboration will have its folder

# checker. if /original exist or not

ori="${ini}/results/originals"        # folder of not elaborated files

if [ -d ${ori} ];then    # true if file exists and it's a directory
  a=0
else
  cd ${ini}/results
  mkdir originals
  mv *.txt ${ori}
fi

end="0"
while [ ${end} -ne 4 ]
do
clear
echo "-------------------------"
echo "-> 2 basins assigned to:"
  if [ -a ${ini}/tmp/ripok.com ];then
    cat ${ini}/tmp/ripok.com
  else
    echo "none"
  fi
echo "-> 3 basins assigned to:"
  if [ -a ${ini}/tmp/riptreok.com ];then
    cat ${ini}/tmp/riptreok.com
  else
    echo "none"
  fi
echo "-------------------------"
echo ""
echo "what do you want to do?"
echo "1: nothing, only plot (Probably the graphic won't be correct)"
echo "2: merge multiple basins for each atom and plot (most used way)"
echo "3: divide multiple basins in different files and plot (to be very precise)"
echo "4: exit"
echo ""
echo -n ">>> "
read end

#-------------------------------------------------------------------------------------------------------------
#
# nothing, only plot (1)

if [ ${end} -eq 1 ]; then

# gnuplot part: to generate a script that will be execute by gnuplot

  cd ${ori}
  ls *.txt | xargs > graph1.gp
  sed -i "s/\ /\"\ u 1:3 w l\,\ \"/g" graph1.gp
  sed -i "s/^/plot \"/g" graph1.gp
  sed -i "s/$/\"\ u 1:3 w l/g" graph1.gp

  sed -i "1 i #!/usr/bin/gnuplot" graph1.gp
  sed -i "2 i\ " graph1.gp
  sed -i "3 i set\ xlabel\ \"IRC\ Step\"" graph1.gp   
  sed -i "4 i set\ ylabel\ \"Electron\ Population\"" graph1.gp
  echo "set terminal wxt persist" >> graph1.gp
  gnuplot graph1.gp
  clear

fi

#-------------------------------------------------------------------------------------------------------------
#
# basins sum (2)

if [ ${end} -eq 2 ]; then

  sum="${ini}/results/summed"
    if [ -d ${sum} ];then   # if folder already exists
      rm -rf ${sum}
      mkdir ${sum}
    else
      echo "Merge multiple basins for each atom and plot"
      cd ${ini}/results
      mkdir summed
    fi

  cp ${ori}/*.txt ${sum}

  cd ${ini}/tmp
  cat ripall.com > ritall.com
  sed -i "s/$/.txt/g" ritall.com
  cd ${sum}

  fii=`cat ${ini}/tmp/ripall.com | wc -l | bc`

  for ((f=1; f<=${fii}; f++))
    do
      not=`cd ${ini}; ls *.out | wc -l | bc`
      name=`sed -n $f' p' ${ini}/tmp/ripall.com`  # name interaction txt
      line=`sed -n $f' p' ${ini}/tmp/ritall.com`  # to choose the file 
      echo "${name}: Done!"
      sed -i "/1,2/ d" ${line}
        for ((i=1; i<=${not}; i++))
          do
            p=`grep "^${i}\ " ${line} | awk '{ sum += $2 } END { print sum}'`
            e=`grep "^${i}\ " ${line} | awk '{ sum += $3 } END { print sum}'`
            echo "$i $p $e" | awk '{ print $1,$2,$3 }' >> ${name}_sum.txt
          done
      sed -i "1 i ${name}" ${name}_sum.txt
      sed -i "2 i\ " ${name}_sum.txt
      rm ${line}
    done

# CLEANER
# before the plot it is useful to clean the useless files (those with no interesting basin variations)

# file list and lines enumeration

  toclean="toclean.com"
  if [ -e ${toclean} ]; then
    rm ${toclean}
  else
    ls *.txt >> toclean.com
    lines=`cat toclean.com | wc -l | bc`
  fi

# starting loop

  for ((i=1; i<=${lines}; i++));
    do
# cerco il primo file della lista con sed

      name=`sed -n "$i p" toclean.com`

      first=`awk '{ print $3 }' ${name} | sed -n '3 p'`
      last=`awk '{ print $3 }' ${name} | sed -n '$ p'`

      if [ $(echo "${first} < ${last}" | bc) -eq 1 ]; then
        gap=$(echo ${last}-${first} | bc)
      else
        gap=$(echo ${first}-${last} | bc)
      fi

# cutoff value

limit=0.2

# deleting useles files

      if [ $(echo "${gap} < ${limit}" | bc) -eq 1 ]; then   # perché sono float
        echo "${name}" >> deleted.com # da mettere in tmp
        rm ${name}
      fi
    done

# check if the cleaner deleted every .txt file therefore it will be skipped

ntxt=`ls 2>/dev/null  *.txt | wc -l | bc`    # ls is also muted :)
  if [ ${ntxt} -eq 0 ];then
    echo "Auto-Cleaner turned off"
       
    cp ${ori}/*.txt ${sum}

    cd ${ini}/tmp
    cat ripall.com > ritall.com
    sed -i "s/$/.txt/g" ritall.com
    cd ${sum}

  fii=`cat ${ini}/tmp/ripall.com | wc -l | bc`

      for ((f=1; f<=${fii}; f++))
        do
          not=`cd ${ini}; ls *.out | wc -l | bc`
          name=`sed -n $f' p' ${ini}/tmp/ripall.com`  # name interaction txt
          line=`sed -n $f' p' ${ini}/tmp/ritall.com`  # to choose the file 
          echo "${name}: Done!"
          sed -i "/1,2/ d" ${line}
            for ((i=1; i<=${not}; i++))
              do
                p=`grep "^${i}\ " ${line} | awk '{ sum += $2 } END { print sum}'`
                e=`grep "^${i}\ " ${line} | awk '{ sum += $3 } END { print sum}'`
                echo "$i $p $e" | awk '{ print $1,$2,$3 }' >> ${name}_sum.txt
              done
            sed -i "1 i ${name}" ${name}_sum.txt
            sed -i "2 i\ " ${name}_sum.txt
            rm ${line}
         done
  fi

rm toclean.com

# gnuplot part: to generate a script that will be execute by gnuplot

  ls *.txt | xargs > graph2.gp
  sed -i "s/\ /\"\ u 1:3 w l\,\ \"/g" graph2.gp
  sed -i "s/^/plot \"/g" graph2.gp
  sed -i "s/$/\"\ u 1:3 w l/g" graph2.gp

  sed -i "1 i #!/usr/bin/gnuplot" graph2.gp
  sed -i "2 i\ " graph2.gp
  sed -i "3 i set\ xlabel\ \"IRC\ Step\"" graph2.gp   
  sed -i "4 i set\ ylabel\ \"Electron\ Population\"" graph2.gp
  echo "set terminal wxt persist" >> graph2.gp
  gnuplot graph2.gp
  
  clear
fi

#-------------------------------------------------------------------------------------------------------------
#
# basins divider (3)

if [ ${end} -eq 3 ]; then

  divi="${ini}/results/divided"
    if [ -d ${divi} ];then   # if folder already exists
        rm -rf ${divi}
        mkdir ${divi}
    else
        echo "Divide multiple basins for each atom and plot"
        mkdir ${divi}
    fi

  cp ${ori}/*.txt ${divi}
  cp ${tmp}/ripall.com ${divi}     # list of atoms with multiple basins

  cd ${divi}

# DIVIDER
# this part will divide each basin for each atom if there are multiple basin for a step

# start with 3 basins (there's a controller)

if [ -a ${tmp}/riptreok.com ]; then
  cp ${tmp}/riptreok.com ${divi}   # list of atoms with 3 basins
  lines=`cat riptreok.com | wc -l | bc`

  for ((i=1; i<=${lines}; i++));
    do
      f=`sed -n "$i p" riptreok.com`
      file=${f}.txt

      echo "elaborating ${f} for three basins"

      awk '{ print $1 }' ${file} > steps.tmp
      sed -i '1,2 d' steps.tmp
      awk '!x[$0]++' steps.tmp > stepsmod.tmp

      step=`cat stepsmod.tmp | wc -l | bc`

        for ((j=1; j<=${step}; j++));
          do
          find=`sed -n "$j p" stepsmod.tmp`
          repe=`grep -c '^'${find}'$' steps.tmp`

            if [ "${repe}" -eq 3 ]; then
              echo "${find} " >> three.tmp     # here 3 times repeatin steps

# search 3 times repeating steps, copy them in a file and take the third line

              grep "^${find} " ${file} >> threelin.tmp
            fi
          done 

        stepm=`cat three.tmp | wc -l | bc`

        for ((l=1; l<=${stepm}; l++))
          do
            k=$((${l}*3))
            sed -n "$k p" threelin.tmp >> ${f}_c.txt
          done

# deleting the last third copied line from the original files to transform then in 2 basins files and elaboration by div.py

        ldel=`cat ${f}_c.txt | wc -l | bc`

        for ((w=1; w<=${ldel}; w++))
          do
            rem=`sed -n "$w p" ${f}_c.txt`
            sed -i "s/${rem}//g" ${file}
            sed -i '/^$/d' ${file}
          done

        rm *.tmp

    done
fi

# elaboration of atoms those contain 2 basins each

    python ${EAAPpath}/div.py   # this script divide if the repeat is 2

# deleting source file just divided

    nldiv=`cat ripall.com | wc -l | bc`

      for ((w=1; w<=${nldiv}; w++))
        do
          rim=`sed -n "$w p" ripall.com`
          rm ${rim}.txt
        done

# CLEANER
# creation list of file and count number of lines

      toclean="toclean.com"
      if [ -e ${toclean} ]; then
        rm ${toclean}
        ls *.txt >> toclean.com
        clelines=`cat ${toclean} | wc -l | bc`
      else
        ls *.txt >> toclean.com
        clelines=`cat ${toclean} | wc -l | bc`
      fi

# deleting from "toclean" the splitted files to be graphed even if the value is less than the cutoff value

      for ((h=1; h<=${nldiv}; h++))
        do
          riml=`sed -n "$h p" ripall.com`
          sed -i "/^${riml}_/d" ${toclean}
        done

# loop

        linesmod=`cat ${toclean} | wc -l | bc`
limit=0.2

      for ((q=1; q<=${linesmod}; q++));
        do

# if statement to have positive value

          dname=`sed -n "$q p" ${toclean}`

          first=`awk '{ print $3 }' ${dname} | sed -n '3 p'`
          last=`awk '{ print $3 }' ${dname} | sed -n '$ p'`

          if [ $(echo "${first} < ${last}" | bc) -eq 1 ]; then
            gap=$(echo ${last}-${first} | bc)
          else
            gap=$(echo ${first}-${last} | bc)
          fi

# deleting useless files

          if [ $(echo "${gap} < ${limit}" | bc) -eq 1 ]; then   # perché sono float
            echo "${dname}" >> deleted.com # da mettere in tmp
            rm ${dname}
          fi
        done

rm toclean.com
rm ripall.com

# gnuplot part: to generate a script that will be execute by gnuplot

      ls *.txt | xargs > graph3.gp
      sed -i "s/\ /\"\ u 1:3 w l\,\ \"/g" graph3.gp
      sed -i "s/^/plot \"/g" graph3.gp
      sed -i "s/$/\"\ u 1:3 w l/g" graph3.gp

      sed -i "1 i #!/usr/bin/gnuplot" graph3.gp
      sed -i "2 i\ " graph3.gp
      sed -i "3 i set\ xlabel\ \"IRC\ Step\"" graph3.gp   
      sed -i "4 i set\ ylabel\ \"Electron\ Population\"" graph3.gp
      echo "set terminal wxt persist" >> graph3.gp
      gnuplot graph3.gp
      clear
fi

#-------------------------------------------------------------------------------------------------------------
#
# exit (4)

if [ ${end} -eq 4 ]; then
  clear
  echo "  Generated files are stored in: ${ini}/results"
fi
done

# final signature with e-mail and GPL

echo ""
echo -e "
         +------------------------------------------------------+
         |  ELF_AnalyserAndPlot  Copyright (C) 2016             |
         |  Author: \033[1mAndrea Darù\033[0m                                 |
         |  This program is free software, distributes with     |
         |  ABSOLUTELY NO WARRANTY under the terms of the GNU   | 
         |  General Public License v3.                          |
         |  In case of errors, questions or comments feel free  |
         |  to contact me! \033[1mandrea.daru.89@gmail.com\033[0m             |
         |  Thanks to use \033[1mELF_AnalyserAndPlot-v1.0\033[0m              |
         |                                                      |
         |       \033[1mIf you use this program please cite me\033[0m         |
         +------------------------------------------------------+"
echo ""

