function columnIndex = getColumnIndex(columnName, cellArrayOfColumnNames)

columnIndex = 0;

for i=1:1:length(cellArrayOfColumnNames)
   if( strfind(char(cellArrayOfColumnNames{i}),columnName) == 1)
      columnIndex = i; 
   end
end

assert(columnIndex ~= 0, ...
    ['Could not find columns with the name: ',columnName]);