function [data, colNames] = getDataAndColumnNames(fileName)

data = csvread(fileName,1,0);
fid = fopen(fileName);
headerLine = fgets(fid);
fclose(fid);
colNames = cell(1, size(data,2));
commaLoc = strfind(headerLine,',');
if(length(headerLine)-(commaLoc(end)) ~= 0)
    commaLoc = [commaLoc,length(headerLine)];
end

p1 = 1;
p2 = 1;
for i=1:1:length(commaLoc)
    p2 = commaLoc(i);
    colNames{i} = headerLine(p1:(p2-1));
    p1=p2+1;
    if(p1 < length(headerLine))
        while(strcmp(headerLine(p1),' ') && p1 <= length(headerLine))
           p1=p1+1; 
        end
    end
end
here=1;
