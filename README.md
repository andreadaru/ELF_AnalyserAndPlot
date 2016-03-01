# **ELF_AnalyserAndPlot-1.0**

### *How to cite:*

[DOI registered in Zenodo.org]

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

    Run the alias you setted up whether you used the automatic installer (install.sh) or you did it manually.

#### *Ideas and future improvements in the subsequent versions:*

 - Possibility to set the cutoff-value for the distance atom-basin (now 1A default) and a checker for bad values;
 - Possibility to set the cutoff-value for the graph cleaner that deletes useless lines (now the default variation is 0.2);
 - Implementation of the choice to have a gap between steps bigger than the value one;
 - Molecule viewer to save the geometry with basins of the important steps;
 - Make it like a software suite with an UI (this is one of the reasons that it's divided in
    different parts with a principal menu);
   ...
 - Implementation of native ELF caculation from wfn files???? (The most difficult right now...).
