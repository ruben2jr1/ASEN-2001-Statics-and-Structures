%%Main Function.
%%
%Read in file to get data.
[force_Counter,moment_Counter,force_Coordinates,magnitude_and_Direction_ExtForces,...
    couple_Moments_Coordinates,magnitude_and_Direction_ExtMoments,support_Locations,...
    type_Direction_reactForces] = readFile("Lab1_input.txt");
%%
%Turn force directions into unit directions.
for i = 1:force_Counter
    mag = sqrt(magnitude_and_Direction_ExtForces(i,2)^2+magnitude_and_Direction_ExtForces(i,3)^2+magnitude_and_Direction_ExtForces(i,4)^2);
    magnitude_and_Direction_ExtForces(i,2:4) = magnitude_and_Direction_ExtForces(i,2:4)/mag;
end
%Turn Moments directions into unit directions.
for i = 1:moment_Counter
    mag = sqrt(magnitude_and_Direction_ExtMoments(i,2)^2+magnitude_and_Direction_ExtMoments(i,3)^2+magnitude_and_Direction_ExtMoments(i,4)^2);
    magnitude_and_Direction_ExtMoments(i,2:4) = magnitude_and_Direction_ExtMoments(i,2:4)/mag;
end
%Turn directions of reaction into unit Directions
for i = 1:6
    mag = sqrt(type_Direction_reactForces{i,2}^2+type_Direction_reactForces{i,3}^2+type_Direction_reactForces{i,4}^2);
    for j = 2:4
        type_Direction_reactForces{i,j} = type_Direction_reactForces{i,j}/mag;
    end
end
%%
% Addition of external force and moment components
% "Formation of b (in Ax = b)"
x_componentAddition_Force = 0;
y_componentAddition_Force = 0;
z_componentAddition_Force = 0;

for i = 1:force_Counter
    x_componentAddition_Force = x_componentAddition_Force + magnitude_and_Direction_ExtForces(i,1)*magnitude_and_Direction_ExtForces(i,2);
    y_componentAddition_Force = y_componentAddition_Force + magnitude_and_Direction_ExtForces(i,1)*magnitude_and_Direction_ExtForces(i,3);
    z_componentAddition_Force = z_componentAddition_Force + magnitude_and_Direction_ExtForces(i,1)*magnitude_and_Direction_ExtForces(i,4);
end
x_componentAddition_Moment = 0;
y_componentAddition_Moment = 0;
z_componentAddition_Moment = 0;

for i = 1:moment_Counter
    x_componentAddition_Moment = x_componentAddition_Moment + magnitude_and_Direction_ExtMoments(i,1)*magnitude_and_Direction_ExtMoments(i,2);
    y_componentAddition_Moment = y_componentAddition_Moment + magnitude_and_Direction_ExtMoments(i,1)*magnitude_and_Direction_ExtMoments(i,3);
    z_componentAddition_Moment = z_componentAddition_Moment + magnitude_and_Direction_ExtMoments(i,1)*magnitude_and_Direction_ExtMoments(i,4);
end

for i =1:force_Counter
    forcevec(i,1:3) = magnitude_and_Direction_ExtForces(i,1)*magnitude_and_Direction_ExtForces(i,2:4);
end
ExtMomentsDueToForces = cross(force_Coordinates,forcevec);
for i =1:force_Counter
    x_componentAddition_Moment = x_componentAddition_Moment + ExtMomentsDueToForces(i,1);
    y_componentAddition_Moment = y_componentAddition_Moment + ExtMomentsDueToForces(i,2);
    z_componentAddition_Moment = z_componentAddition_Moment + ExtMomentsDueToForces(i,3);
end   

b = -[x_componentAddition_Force ; y_componentAddition_Force ; z_componentAddition_Force ; x_componentAddition_Moment ; y_componentAddition_Moment ; z_componentAddition_Moment];

for i =1:6
    ReactionMatrix(i,1) = type_Direction_reactForces{i,2};
    ReactionMatrix(i,2) = type_Direction_reactForces{i,3};
    ReactionMatrix(i,3) = type_Direction_reactForces{i,4};
end
j=1;
for i = 1:6
    if type_Direction_reactForces{i,1} == 'F'
        Forcecross(j,1:3) = ReactionMatrix(i,1:3);
        Locationcross(j,1:3) = support_Locations(i,1:3);
        ind(1,j)= i
        j = j+1;
    end
end
Momentsduetoreactionforces = cross(Locationcross,Forcecross);
A = zeros(6);
j = 1;
k = 1;
for i = 1:6;
    if type_Direction_reactForces{i,1} == 'F'
        A(1:3,i) = Forcecross(j, 1:3);
        A(4:6,i) = Momentsduetoreactionforces(j,1:3);
        j = j+1;
    else
        A(1:3,i) = [0;0;0];
        A(4:6,i) = [type_Direction_reactForces{i,2},type_Direction_reactForces{i,3},type_Direction_reactForces{i,4}];
    end
end

ReactionForcesMoments = A\b