function saveCsvFile2(filename, headers, permission, varargin)
%Function saveCsvFile(filename, headers, varargin)
%
% Function saves the data to a csv-file. Varargin must contain as many
% columns as headers contains column headers. A new function is made
% because Matlab writecsv contains some problematic aspects, e.g. in
% systems with different separator-symbol.

disp(['Writing the results to csv-file ' filename '...']);

if isempty(permission)
    permission = 'w';
end

fileAlreadyExists = exist(filename,'file');

fid = fopen(filename, permission);
sep = ',';

if fid == -1
   disp('Could not open the file for writing.');
   return;
end



%write headers only first time
if ~fileAlreadyExists
    % print first 2 lines
    fprintf(fid, 'sep=%s\n', sep);
    for i=1:length(headers)
        fprintf(fid, '%s', headers{i});

        % print separator if not end-of-line
        if i ~= length(headers)
            fprintf(fid, '%s', sep);
        end
    end
    fprintf(fid,'\n');
else
    disp('File exists, appending data...');
end

rowcount = length(varargin{1});
colcount = length(headers);
for i=1:rowcount
    for j=1:colcount
        colvector = varargin{j};
        
        % check that colvector contains enough values
        if i <= length(colvector)
            if iscell(colvector)
                fprintf(fid, '%s', colvector{i});
            else
                fprintf(fid, '%s', num2str(colvector(i)));
            end
        end
        % print separator if not end-of-line
        if j ~= colcount
           fprintf(fid, '%s', sep); 
        end
        
    end
    fprintf(fid, '\n');
end

fclose(fid);

disp('Done.');