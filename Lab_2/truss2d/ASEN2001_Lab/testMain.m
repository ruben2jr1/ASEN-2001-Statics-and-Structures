%test Main.
clear
clc

inputfile = 'FINALTRUSS_DESIGN.inp';
outputfile = 'FINALTRUSS_DESIGN_OUTPUT.txt';
[joints,connectivity,reacjoints,reacvecs,loadjoints,loadvecs]=readinput(inputfile);
[barforces,reacforces]=forceanalysis(joints,connectivity,reacjoints,reacvecs,loadjoints,loadvecs);
writeoutput(outputfile,inputfile,barforces,reacforces,joints,connectivity,reacjoints,reacvecs,loadjoints,loadvecs);
truss2dmcs('FINALTRUSS_DESIGN.inp');