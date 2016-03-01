#!/usr/bin/python

#
# two basins separator! this part of ELF_AnalyseAndPlot is useful to separate 2 basin associate of a single atom
# the names of the 2-basins files are writed in ripall.com choosing each line to find the file
# the elaboration is performed. Then the value are transformed in array and searching if the first value
# of each line (IRC step) is single or repeated. New files are created for every variation from single to double 
# or vice versa.
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



with open('ripall.com', 'r') as f:
    namelist = [line.strip('\n') for line in f]

#print namelist

def printa(file):
    for x in file:
        print x


for name in namelist:
    print "elaborating "+name+" for two basin"
    with open(name+".txt",'r') as f:
        f.readline()
        f.readline() 
        basins = [map(float,line.split()) for line in f]
        for line in basins:
            line[0] = int(line[0])
#    print basins

    files = [] 

    i = 0
    step = basins[i][0]
    if basins[i+1][0] == step:
        files.append([])
        d1 = 0
        files.append([])
        d2 = 1
        files[d1].append(basins[i])
        files[d2].append(basins[i+1])
        i = 2
        old_two = True
    else:
        files.append([])
        s1 = 0
        files[s1].append(basins[i])
        i = 1
        old_two = False
            
    while i < (len(basins)):
        step = basins[i][0]
        if (i != len(basins) -1):
            check = basins[i+1][0] == step
        else:
            check = False

        if check:
            if old_two:         # continue with 2
                files[d1].append(basins[i])
                files[d2].append(basins[i+1])
            else:               # split to 2
                d1 = s1 + 1
                d2 = d1 + 1
                files.append([])
                files.append([])
                files[d1].append(basins[i])
                files[d2].append(basins[i+1])

            old_two = True
            i+=2
        else:
            if not old_two:     # continue with 1
                files[s1].append(basins[i])
            else:               # merging to 1
                s1 = d2 + 1
                files.append([])
                files[s1].append(basins[i])

            old_two = False
            i+=1
    


    for i,x in enumerate(files):
        with open(name+"_"+str(i)+".txt", 'w') as f:
            for line in x:
                f.write(str(line).strip('[]').replace(',','')+"\n")

