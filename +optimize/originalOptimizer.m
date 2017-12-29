function [mindV, nodes, dv, minParameters] = originalOptimizer(nodes, parameters)
    % Tolerance
    pardif = ones(size(parameters)) * 1;
    dl = 10000000;
    epsi = 0.0005;
    k = 10;
    
    % Ignore NaN
    nrm = @(x) norm(x(~isnan(x)));
    
    % Initial value
    dV = computeDeltaV(nodes, parameters);

    % Optimal
    minParameters = parameters;
    mindV = dV;
    
    it = 0;
    grad = parameters * Inf; % must be bigger than epsi
    while nrm(grad) > epsi
        it = it + 1;
        for i = 1:size(parameters, 1)
            for j = 1:size(parameters, 2)
                if isnan(parameters(i, j))
                   continue;
                end
                
                test = parameters;
                test(i, j) = test(i, j) + pardif(i, j);
                
                grad(i,j) = (computeDeltaV(nodes, test) - dV) / pardif(i,j);
            end
        end
        
        parameters = parameters - grad * dl;
        if ~isnan(dV)
            [dV, nodes, dv] = computeDeltaV(nodes, parameters);
        else
            warning('optimizer:NaN', 'comuteDeltaV crashed. Reducing dl...');
            parameters = minParameters;
            [dV, nodes, dv] = computeDeltaV(nodes, parameters);
            dl = dl / 10;
            grad = parameters * Inf; % while check
        end
        
        if dV < mindV
            mindV = dV;
            minParameters = parameters;
            minIt = it;
        elseif (it - minIt) > k
            return;
        end
        
        disp(['it = ' num2str(it) ' -> nrm(grad) = ' num2str(nrm(grad)) ' -> dV = ' num2str(dV / 1000) ' km/s']);

        if mod(it, 20) == 1
            util.showOrbits(nodes);
        end
    end
end
