function [force_Counter,moment_Counter,force_Coordinates,magnitude_and_Direction_ExtForces,couple_Moments_Coordinates,magnitude_and_Direction_ExtMoments,support_Locations,type_Direction_reactForces] = readFile(name_of_File)
    %name_of_File = "Lab1_input.txt";
    fileID = fopen(name_of_File);
    data = textscan(fileID,'%s','Delimiter',' ',...
    'CommentStyle','#','MultipleDelimsAsOne',1);
    fclose(fileID);

    %Pull in number of forces and moments applied to the object.
    force_Counter = str2double(data{1,1}{1,1});
    moment_Counter = str2double(data{1,1}{2,1});
    support_Counter = 6;
    reactionForces_Counter = 6;
    %%
    if force_Counter >= 1
        %Created a blank matrix to allocate memory for force coordinates.
        force_Coordinates = zeros(force_Counter*3,1);
        %We begin reading from 3rd line. That is after number of forces and moments is given.
        %We also need to tranfer and convert the values from the cell into a array
        %of doubles.
        for i = 3:((3+force_Counter*3) - 1)
            force_Coordinates(i-2,1) = str2double(data{1,1}{i,1});
        end
        force_Coordinates = flipud(rot90(reshape(force_Coordinates,[3,force_Counter])));

        %Allocate memory for magnitude and direction of external forces.
        magnitude_and_Direction_ExtForces = zeros(force_Counter*4,1);
        iterator = 1;
        for i = (i+1):(i+4*force_Counter)
            magnitude_and_Direction_ExtForces(iterator,1) = str2double(data{1,1}{i,1});
            iterator = iterator + 1;
        end
        magnitude_and_Direction_ExtForces = flipud(rot90(reshape(magnitude_and_Direction_ExtForces,[4,force_Counter])));
    elseif force_Counter == 0
        magnitude_and_Direction_ExtForces = 0;
        force_Coordinates = 0;
    end
    %%
    if moment_Counter >= 1
        %Allocate memory for location of external couple moments.
        couple_Moments_Coordinates = zeros(moment_Counter*3,1);
        iterator = 1;
        for i = (i+1):((i+moment_Counter*3))
            couple_Moments_Coordinates(iterator,1) = str2double(data{1,1}{i,1});
            iterator = iterator + 1;
        end
        couple_Moments_Coordinates = flipud(rot90(reshape(couple_Moments_Coordinates,[3,moment_Counter])));

        %Allocate memory for magnitude and direction of external couple moments.
        magnitude_and_Direction_ExtMoments = zeros(moment_Counter*4,1);
        iterator = 1;
        for i = (i+1):((i+moment_Counter*4))
            magnitude_and_Direction_ExtMoments(iterator,1) = str2double(data{1,1}{i,1});
            iterator = iterator + 1;
        end
        magnitude_and_Direction_ExtMoments = flipud(rot90(reshape(magnitude_and_Direction_ExtMoments,[4,moment_Counter])));
    elseif moment_Counter == 0
        magnitude_and_Direction_ExtMoments = 0;
        couple_Moments_Coordinates = 0;
    end
    %%
    %Allocate memory for support locations.
    support_Locations = zeros(support_Counter*3,1);
    iterator = 1;
    for i = (i+1):((i+support_Counter*3))
        support_Locations(iterator,1) = str2double(data{1,1}{i,1});
        iterator = iterator + 1;
    end
    support_Locations = flipud(rot90(reshape(support_Locations,[3,support_Counter])));
    %%
    %Allocate memory for type and direction of reaction forces.
    type_Direction_reactForces = cell(reactionForces_Counter,1);
    iterator = 1;
    for i = (i+1):((i+reactionForces_Counter*4))
        type_Direction_reactForces{iterator,1} = data{1,1}{i,1};
        iterator = iterator + 1;
    end
    type_Direction_reactForces = flipud(rot90(reshape(type_Direction_reactForces,[4,reactionForces_Counter])));
    for j = 1:reactionForces_Counter
        for k = 2:4
            type_Direction_reactForces{j,k} = str2double(type_Direction_reactForces{j,k});
        end
    end
%     [r,c] = size(type_Direction_reactForces);
%     tmpF = cell(r,c);
%     tmpM = cell(r,c);
%     %tmpFM = cell(r,c);
%     jF = 1;
%     jM = 6;
%     for i = 1:6
%         if type_Direction_reactForces{i,1} == 'F'
%             for k = 1:c
%                 tmpF{jF,k} = type_Direction_reactForces{i,k};
%             end
%             jF = jF + 1;
%         elseif type_Direction_reactForces{i,1} == 'M'
%             for k = 1:c
%                 tmpM{jM,k} = type_Direction_reactForces{i,k};
%             end
%             jM = jM - 1;
%         end
%     end
%     sizeOftmpF = jF - 1;
%     sizeOftmpM = 6 - (jM);
%     support_Locations_Tmp = support_Locations;
%     for i = 1:sizeOftmpF
%         for j = 1:c
%             type_Direction_reactForces{i,j} = tmpF{i,j};
%         end
%         for k = 1:3
%            support_Locations(i,k) = support_Locations_Tmp(i,k);
%         end
%     end
%     for i = (sizeOftmpF + 1):(sizeOftmpF + sizeOftmpM)
%         for j = 1:c
%             type_Direction_reactForces{i,j} = tmpM{i,j};
%         end
%         for k = 1:3
%            support_Locations(i,k) = support_Locations_Tmp(i,k);
%         end
%     end
    clear ans data fileID iterator j k 
end