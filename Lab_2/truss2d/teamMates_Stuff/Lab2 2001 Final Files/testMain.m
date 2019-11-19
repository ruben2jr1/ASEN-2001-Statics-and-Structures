%test Main.
clc 
clear all
inputfile = 'meta.inp';
outputfile = 'Output_Mytruss.txt';
[joints,connectivity,reacjoints,reacvecs,loadjoints,loadvecs]=readinput(inputfile);
[barforces,reacforces]=forceanalysis(joints,connectivity,reacjoints,reacvecs,loadjoints,loadvecs);
plottruss(joints,connectivity,barforces,reacjoints);
writeoutput(outputfile,inputfile,barforces,reacforces,joints,connectivity,reacjoints,reacvecs,loadjoints,loadvecs);