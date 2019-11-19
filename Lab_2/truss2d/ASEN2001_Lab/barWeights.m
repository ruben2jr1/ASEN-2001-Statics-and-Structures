%Bar weight
clc
clear all
ro=1.57;
radius=1;

point1x=input('what is the first point x');
point1y=input('what is the first point y');
point1z=input('what is the first point z');

point2x=input('what is the second point x');
point2y=input('what is the second point y');
point2z=input('what is the second point z');

lengthInches=sqrt(((point2x-point1x)^2)+((point2y-point1y)^2)+((point2z-point1z)^2));
lengthCentimeters=2.54*lengthInches;
volume=lengthCentimeters*(3.14*(radius)^2);
massGrams=volume*ro;
massNewtons=massGrams*.01

