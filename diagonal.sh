#!/bin/bash

#
# This file composes the first part of ELF_AnalyserAndPlot. From the out files it extracts geometry of atoms
# and basins for each of them. Next it generates the interaction of a basin with one or more atom/s
# saving them into some files with inside every step of the reaction.
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



# path of the outs where it's running the program
ini=`pwd`

mkdir results
mkdir tmp
clear

echo "Analysing .out files"

not=(*.out)
not=${#num[@]}   # it's the number of steps, it could be useful ;)

# geometry and basins extraction in gjf files

for i in *.out
    do
fname=${i%.out}
echo "%chk=$fname.chk" > ${fname}_basH.gjf
echo "%nprocshared=8" >> ${fname}_basH.gjf
echo "%mem=2GB" >> ${fname}_basH.gjf
echo -e "# geom=connectivity\n" >> ${fname}_basH.gjf
echo -e "$fname\n" >> ${fname}_basH.gjf
echo "0 1" >> ${fname}_basH.gjf


sed '/position/,/search mode/!d' $i | awk '
    BEGIN {getline}
    /^ / {next}
    /^$/ {next}
    {print "",$1 " " $2*0.5292 " " $3*0.5292 " " $4*0.5292}' >> ${fname}_basH.gjf

sed '/assignment/,/unassigned/!d' $i | awk '/ V\(H/ {print " H",$2*0.5292" "$3*0.5292" "$4*0.5292}' >> ${fname}_basH.gjf

sed '/assignment/,/unassigned/!d' $i | awk '/ V\('[^H-H]'/  {print " Bq",$2*0.5292" "$3*0.5292" "$4*0.5292}' >> ${fname}_basH.gjf
echo "" >> ${fname}_basH.gjf
    done

mkdir elf_gjf
mv *_basH.gjf elf_gjf

echo "All file .out analysed"


# analysing of the files just generated

cd ${ini}/elf_gjf

num=(*.gjf)
num=${#num[@]}

clear
echo "Analysing ${num} geometries..."

# creation of the converter taking the names from the file #1

for file in *.gjf
  do
    fname=${file%.gjf}
    fname2=${fname%_elf_basH}
    fnum=${fname2##*-}              # the number on file

    if [ ${fnum} -eq 1 ];then
      cat ${file} > conv.tmp
      sed -i '1,8 d' conv.tmp # delete the first 8 lines
      sed -i '/^[ ]Bq[ ]/d' conv.tmp  # basin elimination
      sed -i '/^$/d' conv.tmp  # delete empty lines
      cat conv.tmp | nl -n ln -s " " > conv2.tmp  # lines enumeration
      sed -i '/[ ]H[ ]/d' conv2.tmp  # H elimination
      awk '{ print $2 }' conv2.tmp > ${ini}/tmp/elfenum.com  # name that ELF gave to atoms (no continuative enumeration)
      awk '{ print $1 }' conv2.tmp > ${ini}/tmp/gaussenum.com  # name for continuative enumeration
      rm conv.tmp
      rm conv2.tmp

cd ${ini}/tmp
      cat elfenum.com > a.com  # temporary file to be elaborated and generate new names
      sed -i "s/[0-9]//g" a.com
      paste -d "" a.com gaussenum.com > gauenum.com
      paste -d " " elfenum.com gauenum.com > converter.tmp  # final file useful to have a continuous enumeration of atoms
rm *.com
    fi
  done

# continue the analysis

cd ${ini}/elf_gjf
mkdir elfab
cp *.gjf elfab
cd ${ini}/elf_gjf/elfab

for file in *.gjf
do
    fname=${file%.gjf}
    fname2=${fname%_elf_basH}
    fnum=${fname2##*-}              # the number on file

# creation of files: molecule geometry, list of basins and a file to transform the atom enumeration starting
# with 1 fo each kind of atom to a consecutive enumeration like GaussView visualize

   sed -i '1,8 d' ${file} # delete the first 8 lines

   sed -i 's/\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ /\ /g' ${file}
   sed -i 's/\ \ \ \ \ \ \ \ \ \ \ \ \ \ /\ /g' ${file}
   sed -i 's/\ \ \ \ \ \ \ \ \ \ \ \ \ /\ /g' ${file}

   sed -i 's/\ \ \ \ /\ /g' ${file}
   sed -i 's/\ \ \ /\ /g' ${file}
   sed -i 's/\ \ /\ /g' ${file}

# geom.com is the the list of the atoms

   cat ${file} >> geom.com 
   sed -i '/^[ ]H[ ]/d' geom.com  # H elimination
   sed -i '/^[ ]Bq[ ]/d' geom.com  # basin elimination
   sed -i '/^$/d' geom.com  # delete empty lines
   g=`cat geom.com | wc -l | bc`

# nline.com is the list of the basins

   cat ${file} | nl -n ln -s "#" >> nline.com
   sed -i 's/[ ]*#//g' nline.com  # delete lines enumeration
   sed -i "1,$g d" nline.com  # delite geom lines
   sed -i '/[ ]H[ ]/d' nline.com  # H elimination
   sed -i 's/[ ]Bq/Bq/g' nline.com
   v=`cat nline.com | wc -l | bc`
   sed -i $v'd' nline.com  # delete empty lines

#done

# division of the carsian values of the atoms in different files

awk '{ print $1 }' geom.com >> ge.txt

awk '{ print $2 }' geom.com >> gx.txt
awk '{ print $3 }' geom.com >> gy.txt
awk '{ print $4 }' geom.com >> gz.txt


# the same for basins...

awk '{ print $1 }' nline.com >> be.txt

awk '{ print $2 }' nline.com >> bx.txt
awk '{ print $3 }' nline.com >> by.txt
awk '{ print $4 }' nline.com >> bz.txt

# cration of file with the possible interacions

   k=`cat nline.com | wc -l | bc`
       for ((i=1; i<=${k}; i++))
       do
         for ((l=1; l<=${k}; l++))
         do
           sed -n "$i p" geom.com >> perm1_tmp.com
         done
       done
      awk '{ print $1 }' perm1_tmp.com >> perm1.com
   h=`cat geom.com | wc -l | bc`
   for ((j=1; j<=${h}; j++))
      do
      awk '{ print $1 }' nline.com >> perm2.com
      done

   paste -d"\_" perm1.com perm2.com >> tot_ge.com

# with a python script now it perform the selection of the right interactions

cp ${EAAPpath}/calc.py ${ini}/elf_gjf/elfab
cd ${ini}/elf_gjf/elfab
python calc.py

# elaboration of text files. Substitution of underscore with a space

awk '{ print $2 }' dnew.txt >> inte.txt
sed -i 's/_/ /g' inte.txt

# from be.txt it looks for basins next it puts with the others of the subsequent steps on a .list file
# that will be change at the end in .txt format

   nbe=`cat be.txt | wc -l | bc`

    for ((w=1; w<=${nbe}; w++))
        do
        line=`sed -n "$w p" be.txt`

        grep "\ ${line}" inte.txt | awk '{ print $1 }' >> a.tmp
        echo "_${line}" >> a.tmp   # WARNING! I'll put a controller for the cutoff selected by default into div.py 
                                   # to check if the value is correct
        cat a.tmp | xargs >>  final.list
rm a.tmp
        done

# here in the future the controller will insert

sed -i "s/\ _/@/g" final.list
sed -i "s/\ /\,/g" final.list
sed -i "s/@/\ /g" final.list
sed -i "s/Bq//g" final.list

mv final.list basin_step-${fnum}.list
mv basin_step-${fnum}.list ${ini}/results



rm *.txt
rm *.com
rm *.py


clear
echo "file number ${fnum} of ${num} completed (it may take some time)"

done

# organizing the results with the interaction as file name
# (creating a.tmp with the searched interaction and scanning .list files)

clear
echo "Elaborating of results"

# generating the list of atoms to be searched

cd ${ini}/results

awk '{ print $1 }' *.list >> a.tmp

awk '!x[$0]++' a.tmp >> g_bas.com    # deleting repeted lines
rm a.tmp

cd ${ini}/elf_gjf
rm -rf elfab

cd ${ini}/results

for bfile in *.list
do
    bnama=${bfile%.list}
    bname=${bnama%-*}
    bnum=${bnama##*-} 


 nbl=`cat g_bas.com | wc -l | bc`

    for ((b=1; b<=${nbl}; b++))
        do
        blind=`sed -n "$b p" g_bas.com`
            rip=`grep "^${blind}\ " ${bname}-${bnum}.list | wc -l | bc`

        grep "^${blind}\ " ${bname}-${bnum}.list >> ${blind}_err.txt
        sed -i "s/$/\ ${bnum}/g" ${blind}_err.txt
        awk '{ print $2"_"$3 }' ${blind}_err.txt >> ${blind}_dis.txt   # writing $1 also the interaction is printed
        rm *_err.txt

#
# looking for 2 or 3 basin around a single atom 
# 

# 2 basins:
            if [ ${rip} -eq 2 ]; then
              echo "${blind}" >> rip.com

# 3 basins:
            elif [ ${rip} -eq 3 ]; then
              echo "${blind}" >> riptre.com
            fi
        done
done

    for ((b=1; b<=${nbl}; b++))
        do
        blind=`sed -n "$b p" g_bas.com`
        sort -k 3 -n ${blind}_dis.txt >> ${blind}.txt
        done

rm *_dis.txt

# if file with 2 repetition exists

  if [ -a rip.com ]; then
    awk '!x[$0]++' rip.com >> ripok.com   # remove repeated lines
    rm rip.com
    cat ripok.com >> ${ini}/tmp/ripall.com
    mv ripok.com ${ini}/tmp  # move in /tmp
  fi

# if file with 3 repetition exists

  if [ -a riptre.com ]; then
    awk '!x[$0]++' riptre.com >> riptreok.com
    rm riptre.com

# deleting 3-basins-atoms name from the 2-basins-atoms list
    if [ -a ${ini}/tmp/ripok.com ];then
      el=`cat riptreok.com | wc -l | bc`
      for ((i=1; i<=${el}; i++))
        do
          lt=`sed -n "$1 p" riptreok.com`
          sed -i "/${lt}/ d" ${ini}/tmp/ripok.com
        done
      mv riptreok.com ${ini}/tmp
    fi
  fi
rm *.list

# extracting the basins values from the out files and organize them into different files

cd ${ini}

oum=(*.out)
oum=${#num[@]}

echo "Extracting basins from ${oum} .out files..."

mkdir elf_data_graph
cp *.out elf_data_graph
cd elf_data_graph

for file in *.out
do
    fname=${file%.out}
    fname2=${fname%_elf}
    fnum=${fname2##*-}              # number on the file's name

# total number of atoms in "a.com" file

   sed -n '7 p' ${file} > a.com
   sed -i 's/[ ]*atomic[ ]*centres[ ]*//g' a.com
a=`sed -n '1,$ p' a.com`

# population value extraction

   sed '/vol.    pop./,/ sum of populations/!d' $file |
   awk -v awkname=$fname '
   BEGIN {print "basin","vol.","pop."}
   /^$/ {next}
   /\(/ {print $1,$2,$3,$4} 
   ' > $fname-tem.list

   v=`cat $fname-tem.list | wc -l | bc`
 for ((l=1; l<= ${v}; l++))
  do
echo "$fnum" >> $fname-tmpquote.list
  done

   paste -d" " $fname-tem.list $fname-tmpquote.list >> $fname-tmp.list
   rm $fname-tem.list
   rm $fname-tmpquote.list

done

rm *.out

# core and valence dividing

for file in *.list
    do 
    fname=${file%-tmp.list}

    grep 'C(' ${file} >> ${fname}_co.aux
    grep 'V(' ${file} >> ${fname}_va.aux
    sed -i 's/C(//g' ${fname}_co.aux
    sed -i 's/)//g' ${fname}_co.aux

    sed -i 's/V(//g' ${fname}_va.aux
    sed -i 's/)//g' ${fname}_va.aux


    done

rm *.list
mkdir aux-tmp
cp *.aux aux-tmp

# creation of the atom list taking a random core file

fux=`ls *co.aux | wc -l | bc`
th=$((${fux}/2))
for file in *${th}*co.aux
do
  awk '{ print $2 }' ${file} >> geom.com
done

mkdir core
mv *co.aux core

   geomline=`cat geom.com | wc -l | bc`

    fva=`ls *va.aux | wc -l | bc`      # number of aux

for dile in *_va.aux
do
    fdile=${dile%-*} 
done

for ((t=1; t<= ${fva}; t++))
  do

name="${fdile}-${t}_elf_va.aux"

   intline=`cat ${fdile}-${t}_*_va.aux | wc -l | bc`

   tint=$((${intline}+${geomline}))
 for ((d=$((${geomline}+1)); d<= ${tint}; d++))
   do
     grep -i  '^'${d} ${name} >> ti${d}.txt  #grep ${d} like first column
   done
echo "Processing file ${t} of ${fva}"
  done

        awk '{ print $1"_"$5,$3,$4 }' ti*.txt >> ni.txt
mv *ni*.txt ${ini}/results
cd ${ini}
rm -rf elf_data_graph

# the different names are printed like: "basin_step" with the underscore to make easier the search
# look for the name in that way and insert the corresponding value

cd ${ini}/results

ls >> f_bas.com    # names of txt files ([interaction].txt)

sed -i 's/g_bas.com//g' f_bas.com
sed -i 's/f_bas.com//g' f_bas.com
sed -i 's/ni.txt//g' f_bas.com
sed -i '/^$/d' f_bas.com 

cat f_bas.com >> name_basELF.com    # name of interaction in the ELF way enumeration
   sed -i 's/.txt//g' name_basELF.com          # interaction name gave by ELF

# modification of name in name_basELF.com with the real one, enumerate in a continuous way. 
# also for ripall.com ripok.com and riptreok.com (that contains multiple-basins-atom's name)

cat name_basELF.com > name_bas.com

   nlconv=`cat ${ini}/tmp/converter.tmp | wc -l | bc`   # number of lines in converter.tmp
for ((u=1; u<=${nlconv}; u++))  
  do
    origin=`awk '{ print $1 }' ${ini}/tmp/converter.tmp | sed -n "$u p"`
    new=`awk '{ print $2 }' ${ini}/tmp/converter.tmp | sed -n "$u p"`
    
    sed -i "s/^${origin}$/\#${new}/g" name_bas.com
    sed -i "s/,${origin}$/,\.${new}/g" name_bas.com
    sed -i "s/^${origin},/${new}\.,/g" name_bas.com
  done
    sed -i "s/\#//g" name_bas.com
    sed -i "s/\.//g" name_bas.com

paste -d " " name_basELF.com name_bas.com > ${ini}/tmp/name_bas_conv.tmp   # copy to compare the conversions of the names before and after

# the same for the files with atom with basins repited names (ripall, ripok and riptreok)

cd ${ini}/tmp

# if at least a .com file exists in /tmp

if [ -a ripok.com ] || [ -a riptreok.com ] || [ -a ripall.com ] ; then
  for r in rip*.com
    do    
      nlconv=`cat converter.tmp | wc -l | bc`   # number of lines in converter.tmp
      for ((u=1; u<=${nlconv}; u++))
        do
          origin=`awk '{ print $1 }' converter.tmp | sed -n "$u p"`
          new=`awk '{ print $2 }' converter.tmp | sed -n "$u p"`
    
          sed -i "s/^${origin}$/\#${new}/g" $r
          sed -i "s/,${origin}$/,\.${new}/g" $r
          sed -i "s/^${origin},/${new}\.,/g" $r
        done
    done

  for r in rip*.com
    do
      sed -i "s/\#//g" $r
      sed -i "s/\.//g" $r
    done
fi
# organise file by name (continuous and ELF way) and ordening the line into the different files

cd ${ini}/results

   lini=`cat f_bas.com | wc -l | bc`
   tl=`cat name_bas.com | wc -l | bc`
for ((t=1; t<=${lini}; t++))  
  do
    f=`sed -n "$t p" f_bas.com` # chosing by name the interaction file
    fli=`cat ${f} | wc -l | bc`   # lines of txt final files (the same of lines in f_bas.com)
      for ((i=1; i<=${fli}; i++))
        do
          li=`sed -n "$i p" ${f}`   # name of the file takes from f_bas.com to search it
          nali=`sed -n "$t p" name_bas.com`  # name of interaction in the ELF way enumeration
          grep '^'${li}'\ ' ni.txt >> ${nali}_finerr.list
        done
    sed -i "s/_/\ /g" ${nali}_finerr.list
    awk '{ print $2,$3,$4 }' ${nali}_finerr.list >> ${nali}_finr.list
    sort -k 1 -n ${nali}_finr.list >> ${nali}_fin.list
    sed -i "1 i ${nali}" ${nali}_fin.list
    sed -i "2 i\ " ${nali}_fin.list
echo "$f converted to ${nali}.txt"
  done

rm *.txt
rm *.com
rm *_finerr.list
rm *_finr.list

# changing the format list -> txt

for file in *.list
do
    mv -i "${file}" "${file/_fin.list/.txt}"
done

# now the other part with grapher, merger, divider and cleaner to plot the results

