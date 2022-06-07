function data = read_file(file_name)
    %function that reads .mat files and returns original data structure
    primary_data = load(file_name);
    data = primary_data;
end