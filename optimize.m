function [dV, nodes, parameters, grad, it] = optimize(nodes, parameters)
    % Tolerance
    pardif = ones(size(parameters)) * 1;
    dl = 10000000;
    epsi = 0.0001;
    
    % Ignore NaN
    nrm = @(x) norm(x(~isnan(x)));
    
    % Initial value
    dV = computeDeltaV(nodes, parameters);
    
%     figure;
%     hold('on');
%     colors = ['r' 'r' 'r' 'r'; 'g' 'b' 'y' 'm'; 'c' 'r' 'r' 'r'];
    
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
%                 plot(it, grad(i, j), ['x' colors(i, j)]);
%                 pause(0.001);
            end
        end

        parameters = parameters - grad * dl;
        [dV, nodes] = computeDeltaV(nodes, parameters);
        
%         plot(parameters(1, 1), dV, ['x' colors(3, 1)]);
%         pause(0.001);
        
%         disp(['it = ' num2str(it) ' -> ' num2str(nrm(grad)) ' -> ' num2str(dV)]);

        if mod(it, 20) == 1
            util.showOrbits(nodes);
        end
    end
end
