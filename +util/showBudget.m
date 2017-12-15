function showBudget(dv)
    figure;
    bar(dv / 1000);
    
    xlabel('Nodes', 'Interpreter', 'latex');
    ylabel('$$\Delta v$$ [km/s]', 'Interpreter', 'latex');
end
