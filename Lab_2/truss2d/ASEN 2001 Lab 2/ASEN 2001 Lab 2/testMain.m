%Main Script which calls all functions
%Housekeeping
clc 
clear all
%Define which input file will be loaded
inputfile = 'Final_Design_Loaded.inp';
%Define which file output will be loaded to
outputfile = 'Final_Design_Loaded.txt';
%Read input file and return information about the joints, members and
%reaction forces
[joints,connectivity,reacjoints,reacvecs,loadjoints,loadvecs]=readinput(inputfile);
%Call the forceanalysis function with the joint, member and recation force
%data, function returns forces in bars and the reaction forces
[barforces,reacforces]=forceanalysis(joints,connectivity,reacjoints,reacvecs,loadjoints,loadvecs);
%plot the truss with the forces in the members
plottruss(joints,connectivity,barforces,reacjoints);
%Write data to output file
writeoutput(outputfile,inputfile,barforces,reacforces,joints,connectivity,reacjoints,reacvecs,loadjoints,loadvecs);