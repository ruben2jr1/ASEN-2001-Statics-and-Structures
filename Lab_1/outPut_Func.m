function [] = outPut_Func(fileID,numberOfExtForces,numberOfExtMoments,magnitude_and_Direction_ExtForces,magnitude_and_Direction_ExtMoments,type_Direction_reactForces,b,A,x,support_Locations)%,reaction_Moments_Forces)

fprintf(fileID,'# Process for general solution.\n');
fprintf(fileID,'# For %d Forces and %d Moments\n',numberOfExtForces, numberOfExtMoments);
fprintf(fileID,'# First step is to make all appropriate matrices unit matrices.\n');
fprintf(fileID,'# This yields.\n');
% Mag and unit direction Ext Forces:
fprintf(fileID,'# The magnitude and unit direction of external forces:\n');
fprintf(fileID,'# Mag  i  j  k\n');
for i = 1:numberOfExtForces
    for j = 1:4
       if j ~= 4
           fprintf(fileID,'  %.2f',magnitude_and_Direction_ExtForces(i,j));
       elseif j == 4
           fprintf(fileID,' %.2f\n',magnitude_and_Direction_ExtForces(i,j));
       end
    end
end
% Mag and unit Direction ext moments
fprintf(fileID,'# The magnitude and unit direction of external moments:\n');
fprintf(fileID,'# Mag  i  j  k\n');
for i = 1:numberOfExtMoments
    for j = 1:4
       if j ~= 4
           fprintf(fileID,'  %.2f',magnitude_and_Direction_ExtMoments(i,j));
       elseif j == 4
           fprintf(fileID,' %.2f\n',magnitude_and_Direction_ExtMoments(i,j));
       end
    end
end
% Mag and unit direction for reaction forces
fprintf(fileID,'# The magnitude and unit direction of reaction Forces/Moments:\n');
fprintf(fileID,'# Reaction Number  type(F/M)  i  j  k\n');
for i = 1:6
    for j = 1:4
       if j ~= 4
           if j == 1
               fprintf(fileID,'  Reaction:  %d  %c',i,type_Direction_reactForces{i,j});
           else
               fprintf(fileID,'  %.2f',type_Direction_reactForces{i,j});
           end
       elseif j == 4
           fprintf(fileID,' %.2f\n',type_Direction_reactForces{i,j});
       end
    end
end
% Formed b 
fprintf(fileID,'# We then computed b in Ax = b by adding all force components and moment components:\n');
fprintf(fileID,'# b = [%.2f, %.2f, %.2f, %.2f, %.2f, %.2f]\n',b(1,1),b(2,1),b(3,1),b(4,1),b(5,1),b(6,1));
% % position of reaction forces cross force
% fprintf(fileID,'# We then find the moments caused by the reaction forces resulting in:\n');
% for i = 1:6
%     for j = 1:3
%         if j ~= 3
%            fprintf(fileID,'  %.2f',reaction_Moments_Forces(i,j));
%        elseif j == 3
%            fprintf(fileID,' %.2f\n',reaction_Moments_Forces(i,j));
%        end
%     end
% end

% A is
fprintf(fileID,'# We can then calculate our A in Ax = b:\n');
for i = 1:6
    for j = 1:6
        if j ~= 6
           fprintf(fileID,'  %.2f',A(i,j));
       elseif j == 6
           fprintf(fileID,' %.2f\n',A(i,j));
       end
    end
end
% solve Ax = b
fprintf(fileID,'# Which yields a solution x = A/b:\n');
counter = 0;
for i = 1:6
    if x(i,1) ~= 0
        counter = counter + 1;
        fprintf(fileID,'Reaction %d: %c with magnitude %.2f With direction: <%.2f , %.2f , %.2f> @ position: (%.2f , %.2f , %.2f)\n',i,type_Direction_reactForces{i,1},x(i,1), type_Direction_reactForces{i,2}, type_Direction_reactForces{i,3}, type_Direction_reactForces{i,4},support_Locations(i,1),support_Locations(i,2),support_Locations(i,3));
    end
end
