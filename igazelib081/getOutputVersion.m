function version = getOutputVersion(name, folder)

f=dir(folder); %get all file
a = struct2cell(f); %store 'em to cell
b = (strfind(a(1,:), 'Pupil_results')); %find matches
n_files_in_folder = length(cell2mat(b)) %count 'em
version = num2str(n_files_in_folder+1)

%'output version:'
%version 

end