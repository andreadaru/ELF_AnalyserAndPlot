#!/usr/bin/python

#
# this part of ELF_AnalyserAndPlot is useful to calculate the distance from an atom with 
# each basin taking the cartesian coordinates of atoms and basins that are divided in 
# different files. for ex gx.txt x-coordinates of atoms and bx.txt x-coordinates
# of basins and the same for gy and gz and by and bz.
# To find the distance is like to calculate the diagonal of a parallelepipedon
# with the atom on a vertex and the basin on the opposite one
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



# start for x

gx = open('gx.txt', 'r')
glx = gx.readlines()
for i in range(0, len(glx)):
    glx[i] = float(glx[i].strip("\n"))

bx = open('bx.txt', 'r')
blx = bx.readlines()
for j in range(0, len(blx)):
    blx[j] = float(blx[j].strip("\n"))

al = open('apy.txt', 'a')

a = 0
for n in range(0, len(glx)):
    for m in range(0, len(blx)):

        a = glx[n] - blx[m]

        al.write(str(a))
        al.write("\n")

gx.close()
bx.close()

# now for y

gy = open('gy.txt', 'r')
gly = gy.readlines()
for i in range(0, len(gly)):
    gly[i] = float(gly[i].strip("\n"))

by = open('by.txt', 'r')
bly = by.readlines()
for j in range(0, len(bly)):
    bly[j] = float(bly[j].strip("\n"))

bl = open('bpy.txt', 'a')

b = 0
for n in range(0, len(gly)):
    for m in range(0, len(bly)):

        b = gly[n] - bly[m]

        bl.write(str(b))
        bl.write("\n")

gy.close()
by.close()

# now for z

gz = open('gz.txt', 'r')
glz = gz.readlines()
for i in range(0, len(glz)):
    glz[i] = float(glz[i].strip("\n"))

bz = open('bz.txt', 'r')
blz = bz.readlines()
for j in range(0, len(blz)):
    blz[j] = float(blz[j].strip("\n"))

cl = open('cpy.txt', 'a')

c = 0
for n in range(0, len(glz)):
    for m in range(0, len(blz)):

        c = glz[n] - blz[m]

        cl.write(str(c))
        cl.write("\n")

gx.close()
bx.close()

al.close()
bl.close()
cl.close()

# diagonal

dl = open('diagonals_comp.txt', 'a')
dl_tmp = open('diagonals_tmp.txt', 'a')

import math

wa = open('apy.txt', 'r')
wla = wa.readlines()
for j in range(0, len(wla)):
    wla[j] = float(wla[j].strip("\n"))

wb = open('bpy.txt', 'r')
wlb = wb.readlines()
for j in range(0, len(wlb)):
    wlb[j] = float(wlb[j].strip("\n"))

wc = open('cpy.txt', 'r')
wlc = wc.readlines()
for j in range(0, len(wlc)):
    wlc[j] = float(wlc[j].strip("\n"))

tg = open('tot_ge.com', 'r')
tgl = tg.readlines()


for h in range(0, len(wla)):
    aq = float(wla[h])
    bq = float(wlb[h])
    cq = float(wlc[h])
    dq = aq**2 + bq**2 + cq**2
    d = math.sqrt(dq)
    u = tgl[h]

    dl.write(str(d))
    dl.write(" ")
    dl.write(str(u))

    dl_tmp.write(str(d))
    dl_tmp.write("\n")

wa.close()
wb.close()
wc.close()
tg.close()
dl.close()
dl_tmp.close()

dnew = open ('dnew.txt', 'a')

di = open('diagonals_tmp.txt', 'r')
dia = di.readlines()
for j in range(0, len(dia)):
    dia[j] = float(dia[j].strip("\n"))

dico = open('diagonals_comp.txt', 'r')
diaco = dico.readlines()


for j in range(0, len(diaco)):
    varj = float(dia[j])

    if float(dia[j]) < float(0.9):
        dnew.write(str(diaco[j]))


dnew.close()
di.close()
dico.close()

