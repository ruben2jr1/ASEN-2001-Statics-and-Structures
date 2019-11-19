%Read file Function for Lab 2.
name_of_File = "11bars.inp";
fileID = fopen(name_of_File);
    data = textscan(fileID,'%s','Delimiter',' ',...
    'CommentStyle','#','MultipleDelimsAsOne',1);
fclose(fileID);

numberOfJoints = str2double(data{1,1}{1,1});
numberOfBars = str2double(data{1,1}{2,1});
numberOfReactions = str2double(data{1,1}{3,1});
numberOfLoads = str2double(data{1,1}{4,1});

for i = 5:(numberOfJoints*3)
    
end
    
    