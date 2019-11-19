YorN = 'y';
while (YorN(1,1) == 'Y') || (YorN(1,1) == 'y')
    fprintf('ASEN 2001: Lab 1\n');
    prompt1 = 'The file should be in the same directory as the main file.\nWhat is the name of the file you wish to process(include ".txt")? --> ';
    nameOfFile = input(prompt1,'s');
    %%Main Function.
    %%
    %Read in file to get data.
    [force_Counter,moment_Counter,force_Coordinates,magnitude_and_Direction_ExtForces,...
        couple_Moments_Coordinates,magnitude_and_Direction_ExtMoments,support_Locations,...
        type_Direction_reactForces] = readFile(nameOfFile);
    %%
    %Turn force directions into unit directions.
    if (force_Counter ~= 0)
        for i = 1:force_Counter
            mag = sqrt(magnitude_and_Direction_ExtForces(i,2)^2+magnitude_and_Direction_ExtForces(i,3)^2+magnitude_and_Direction_ExtForces(i,4)^2);
            magnitude_and_Direction_ExtForces(i,2:4) = magnitude_and_Direction_ExtForces(i,2:4)/mag;
        end
    end
    %Turn Moments directions into unit directions.
    if (moment_Counter ~= 0)
        for i = 1:moment_Counter
            mag = sqrt(magnitude_and_Direction_ExtMoments(i,2)^2+magnitude_and_Direction_ExtMoments(i,3)^2+magnitude_and_Direction_ExtMoments(i,4)^2);
            magnitude_and_Direction_ExtMoments(i,2:4) = magnitude_and_Direction_ExtMoments(i,2:4)/mag;
        end
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
    
    % if number of forces is zero then no addition required.
    if (force_Counter ~= 0)
        for i = 1:force_Counter
            x_componentAddition_Force = x_componentAddition_Force + magnitude_and_Direction_ExtForces(i,1)*magnitude_and_Direction_ExtForces(i,2);
            y_componentAddition_Force = y_componentAddition_Force + magnitude_and_Direction_ExtForces(i,1)*magnitude_and_Direction_ExtForces(i,3);
            z_componentAddition_Force = z_componentAddition_Force + magnitude_and_Direction_ExtForces(i,1)*magnitude_and_Direction_ExtForces(i,4);
        end
    end
    x_componentAddition_Moment = 0;
    y_componentAddition_Moment = 0;
    z_componentAddition_Moment = 0;
    
    % if number of moments is zero then no addition required.
    if (moment_Counter ~= 0)
        for i = 1:moment_Counter
            x_componentAddition_Moment = x_componentAddition_Moment + magnitude_and_Direction_ExtMoments(i,1)*magnitude_and_Direction_ExtMoments(i,2);
            y_componentAddition_Moment = y_componentAddition_Moment + magnitude_and_Direction_ExtMoments(i,1)*magnitude_and_Direction_ExtMoments(i,3);
            z_componentAddition_Moment = z_componentAddition_Moment + magnitude_and_Direction_ExtMoments(i,1)*magnitude_and_Direction_ExtMoments(i,4);
        end
    end

    % External moments caused by external Forces:
    if (force_Counter ~= 0)
        ext_Moments_Forces = zeros(force_Counter,3);
        for i = 1:force_Counter
            ext_Moments_Forces(i,1:3) = cross(force_Coordinates(i,:),magnitude_and_Direction_ExtForces(i,1)*magnitude_and_Direction_ExtForces(i,2:4));
            x_componentAddition_Moment = x_componentAddition_Moment + ext_Moments_Forces(i,1);
            y_componentAddition_Moment = y_componentAddition_Moment + ext_Moments_Forces(i,2);
            z_componentAddition_Moment = z_componentAddition_Moment + ext_Moments_Forces(i,3);
        end
    end
    
    b(1,1) = -x_componentAddition_Force;
    b(2,1) = -y_componentAddition_Force;
    b(3,1) = -z_componentAddition_Force; 
    b(4,1) = -x_componentAddition_Moment; 
    b(5,1) = -y_componentAddition_Moment; 
    b(6,1) = -z_componentAddition_Moment;

    %%
    % position of supports cross direction of reaction forces
    reaction_Moments_Forces = zeros(6,3);
    number_of_reaction_Forces = 0;
    for i = 1:6
        if type_Direction_reactForces{i,1} == 'F'
            for j = 1:3
                   reaction_Moments_Forces(i,j) = type_Direction_reactForces{i,j + 1};
            end
            reaction_Moments_Forces(i,:) = cross(support_Locations(i,:),reaction_Moments_Forces(i,:));
            number_of_reaction_Forces = number_of_reaction_Forces + 1;
        end
    end

    %%
    % Formation of A in Ax = b:
    A = zeros(6,6);
    for i = 1:3
        for j = 1:6
            if type_Direction_reactForces{j,1} == 'F'
                A(i,j) = type_Direction_reactForces{j,i+1};
            else
                A(i,j) = 0;
            end
        end
    end
    
    if (number_of_reaction_Forces ~= 0)
        for i = 4:6
            for j = 1:6
                if (type_Direction_reactForces{j,1} == 'F')
                    A(i,j) = reaction_Moments_Forces(j,i - 3);
                elseif (type_Direction_reactForces{j,1} == 'M')
                    A(i,j) = type_Direction_reactForces{j,i - 2};
                end
            end
        end

%         for i = 4:6
%             for j = (number_of_reaction_Forces + 1):6
%                 A(i,j) = type_Direction_reactForces{j,i - 2};
%             end
%         end
    end
    %%
    % Solve system
    x = A\b;
    %%
    % Write to file.
    prompt2 = '';
    fileID = fopen('outputFile_ASEN_2001_Lab_1.txt','w');
    outPut_Func(fileID,force_Counter,moment_Counter,magnitude_and_Direction_ExtForces,magnitude_and_Direction_ExtMoments,type_Direction_reactForces,b,A,x,support_Locations);
    fclose(fileID);
    prompt = 'Would you like to run the program again? (yes or no)';
    YorN = input(prompt,'s');
end