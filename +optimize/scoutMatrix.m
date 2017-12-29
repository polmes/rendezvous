% Scout matrix generator
function scout = scoutMatrix(parameters)
    % Inputs
    nnod = size(parameters, 1);
    ndim = size(parameters, 2); % t + xyz

    if ndim ~= 4
        throw(MException('OrbitFactory:ndim', ...
            'scoutOptimizer not prepared for such input'));
    end
    
    dim = ones(1,nnod);
    for i = 1:nnod
        if ~isnan(parameters(i, 2))
            dim(i) = ndim; % 4 free parameters
        end
    end

    % Predefined matrices
    grav =   [0 0 0 0; % gravity assist node
              1 0 0 0];

    gene =  [0 0 0 0; % generic node with t,x,y,z
             1 0 0 0;
             0 1 0 0;
             1 1 0 0;
             0 0 1 0;
             1 0 1 0;
             0 1 1 0;
             1 1 1 0;
             0 0 0 1;
             1 0 0 1;
             0 1 0 1;
             1 1 0 1;
             0 0 1 1;
             1 0 1 1;
             0 1 1 1;
             1 1 1 1];

    % Calculate combinations
    npermut = (2*ones(size(dim))).^dim;
    
    c = 0; % current scout layer
    cguess = nnod*2^(2*ndim); % initial guess on the value of c
    scout = zeros(nnod,ndim,cguess);
    for i = 1:(nnod-1)
       for j = 1:npermut(i)
           for k = 1:npermut(i+1)
               if(j+k > 2) % avoid empty cases
                   % Update layer
                   c = c + 1;
                   % Current node
                   if(npermut(i) == 16)
                       scout(i,:,c) = gene(j,:);
                   else
                       scout(i,:,c) = grav(j,:);               
                   end
                   % Following node
                   if(npermut(i+1) == 16)
                       scout(i+1,:,c) = gene(k,:);
                   else
                       scout(i+1,:,c) = grav(k,:);               
                   end
               end
           end
       end
    end
    
    % Resize scout 
    scout(:,:,(c+1):end) = [];
end
