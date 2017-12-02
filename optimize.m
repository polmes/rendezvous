function [dV,params,grad,it]=optimize(fun,initparams,pardif,dl,epsi)
    params=initparams;
    dV=fun(params);
    grad = params*Inf;%Initial gradient. Must be bigger than epsi

    nrm = @(x)norm(x(~isnan(x)));

    it=0;
    while(nrm(grad)>epsi)
      it=it+1;
      for i=1:size(params,1)
        for j=1:size(params,2)
          if(isnan(params(i,j)))
            continue
          end
          testparams=params;
          testparams(i,j)=testparams(i,j)+pardif(i,j);

          %grad(i,j)=(computeDeltaV(testparams)-dV)/pardif(i,j);
          grad(i,j)=(fun(testparams)-dV)/pardif(i,j);
        end
      end
%       testparams

      params=params-grad*dl;
      dV=fun(params);
      nrm(grad)
    end

%     dV
%     params
%     grad
%     it

end
