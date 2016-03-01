# **ELF_AnalyserAndPlot-1.0**

### *How to cite:*

[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.46794.svg)](http://dx.doi.org/10.5281/zenodo.46794)

### *Requested repositories:*

 - GNU Sed (I tested with v4.2.2);
 - GNU Awk (I tested with v4.0.1);
 - Python 2.x (I tested with v2.7.6);
 - Gnuplot (I tested with v4.6).

### *How to install:*

    Use the installer "install.sh" and follow the instruction.

For manual installation create a folder, paste inside all files and create an alias that executes "_main.sh_" 
from that folder then insert an environmental variable writing: _export EAAPpath="here the path where find files"_. 
Anyway, you can find more informations reading inside _install.sh_.

### *How to use:*

    Run the alias you setted up (whether you used the automatic installer or you did it manually)
    into a folder that contains the out-files generated from ELF calculation.

The _name_ of the file have to be with a part of your choosing, after this a _dash_ and the progressive _number_
from 1 to the last step (without interruptions) and after the number an _underscore_ and the word "_elf_"

__example:__ "name you prefer"-"number"_elf.out

#### *Features:*

 - Extract geometry of atoms and basins from the out-files generated;
 - Extract values for each basin;
 - Create association between basin/s and atom/s;
 - Divide in different files the interactions between atoms and values in each point;
 - Clean useless interaction (the ones that don't suffer variations);
 - Plot with lines the values in a graph, giving different options about the elaboration.

#### *Ideas and future improvements in the subsequent versions:*

 - Possibility to set the cutoff-value for the distance atom-basin (now 1A default) and a checker for bad values;
 - Possibility to set the cutoff-value for the graph cleaner that deletes useless lines (now the default variation is 0.2);
 - Implementation of the choice to have a gap between steps bigger than the value one;
 - Molecule viewer to save the geometry with basins of the important steps;
 - Make it like a software suite with an UI (this is one of the reasons that it's divided in
    different parts with a principal menu);
   ...
 - Implementation of native ELF caculation from wfn files???? (The most difficult right now...).
