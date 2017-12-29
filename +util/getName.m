function name = getName(filename)
    [~, name, ~] = fileparts(filename);
    name = strtok(name, 'input_');
end
