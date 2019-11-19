%Bar weight
clc
clear all
ro=1.57;
outerRadius=.5;
innerRadius=.4;

point1x=input('what is the first point x');
point1y=input('what is the first point y');
point1z=input('what is the first point z');

point2x=input('what is the second point x');
point2y=input('what is the second point y');
point2z=input('what is the second point z');

lengthInches=sqrt(((point2x-point1x)^2)+((point2y-point1y)^2)+((point2z-point1z)^2))
lengthCentimeters=2.54*lengthInches;
volumeOut=lengthCentimeters*(3.14*(outerRadius)^2);
volumeIn=lengthCentimeters*(3.14*(innerRadius)^2);
volume=volumeOut-volumeIn;
massGrams=volume*ro;
massNewtons=massGrams*.01

