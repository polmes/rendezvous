% Scout matrix generator
function scout = scoutMatrixRan(parameters)
    % Inputs
    nnod = size(parameters, 1);
    ndim = size(parameters, 2); % t + xyz 
    ncases = 3000;

    % Generate n number of directions to evaluate
    scout = zeros(nnod,ndim,ncases);
    for i = 1:ncases
        scout(:, :, i) = randi([0 1], nnod, ndim);
    end
end
