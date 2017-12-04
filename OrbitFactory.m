function orbit = OrbitFactory(varargin)
    if nargin == 1 % (node)
        node = varargin{1};
        [sma, ecc, inc, arg, lan, mna] = util.rvt2orbit(node.r, noode.vo, node.t);
    elseif nargin == 6 % (sma, ecc, inc, arg, lan, mna)
        sma = varargin{1};
        ecc = varargin{2};
        inc = varargin{3};
        arg = varargin{4};
        lan = varargin{5};
        mna = varargin{6};
        
        % Singularities
        [sma, ecc, inc] = util.checkSingularities(sma, ecc, inc);
    else
        throw(MException('OrbitFactory:nargin', ...
            'Invalid number of arguments when using OrbitFactory'));
        % access error stack via MException.last
    end
    
    if ecc < 1
        orbit = EllipticOrbit(sma, ecc, inc, arg, lan, mna);
    elseif ecc > 1
        orbit = HyperbolicOrbit(sma, ecc, inc, arg, lan, mna);
    end
end
