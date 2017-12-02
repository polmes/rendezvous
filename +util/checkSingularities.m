function [sma, ecc, inc] = checkSingularities(sma, ecc, inc)
    if ecc > 1 && sma > 0
        throw(MException('checkSingularities:incompatibility', ...
            'Incompatibility found: sma > 0 with ecc > 1'));
    elseif ecc < 1 && sma < 0
        throw(MException('checkSingularities:incompatibility', ...
            'Incompatibility found: sma < 0 with ecc < 1'));
    end
    
    if ecc == 0
        warning('checkSingularities:ecc', 'Singularity: ecc = 0');
        ecc = ecc + 1e-10;
    elseif ecc == 1
        warning('checkSingularities:ecc', 'Singularity: ecc = 1');
        ecc = ecc + 1e-10;
    end
    
    if mod(inc, pi) == 0
        warning('checkSingularities:inc', 'Singularity: inc = 0');
        inc = inc + 1e-10;
    end
end
