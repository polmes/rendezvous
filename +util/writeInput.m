function newInput = writeInput(filename, parameters)
    data = load(filename);
    input = data.input;
    
    if size(parameters, 1) ~= height(input)
        throw(MException('writeInput:size', ...
            'New parameters do not match original input size'));
    end
    
    input.t = parameters(1:end, 1);
    input.r = parameters(1:end, 2:end);
    
    newInput = input;
end
