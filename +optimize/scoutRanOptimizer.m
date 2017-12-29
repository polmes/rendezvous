function [mindV, nodes, dv, minParameters] = scoutRanOptimizer(nodes, parameters)
    % Tolerance
    pardif = 1; % time x y z step for grad
    dl = 1e5; % 1e7
    epsi = 0.0005;
    k = 10;
    minIt = 0;
    
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
        
        % Calculate ran
        scout = optimize.scoutMatrixRan(parameters);
        
        % Calculate grad
        grad = zeros(size(parameters));
        for i = 1:size(scout,3)
           test = parameters + scout(:, :, i) * pardif;
           grad_norm = (computeDeltaV(nodes, test) - dV) / pardif;
           grad = grad + scout(:, :, i) * grad_norm / nnz(scout(:, :, i));
        end

        % Use grad
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

%         disp(' ');
%         disp('change = ');
%         change = 1e6 * grad * dl ./ parameters;
%         disp(change);

        if mod(it, 20) == 1
            util.showOrbits(nodes);  
        end
    end
end
