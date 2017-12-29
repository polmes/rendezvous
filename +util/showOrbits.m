function showOrbits(nodes)
    N = length(nodes);
    NN = 100;
    
    au = 149597870700; % 1 [AU] in [m]
    
    clf;
    hold('on');
    
    % Sun
    scatter3(0, 0, 0, 'k*');
    
    for i = 1:N
        r = nodes(i).r;
        r = r / au;
        scatter3(r(1), r(2), r(3), 'filled');
    end
        
    for i = 1:N-1
        orbit = OrbitFactory(nodes(i));
        
        rs = zeros(3, NN);
        ts = linspace(nodes(i).t, nodes(i+1).t, NN);
        for j = 1:NN
            rs(:, j) = orbit.toIJK(ts(j));
        end
        
        rs = rs / au;
        plot3(rs(1, :), rs(2, :), rs(3, :));
    end
    
    nodeNames = 1:N;
    legend(["Sun"; string(num2str(nodeNames(:)))]);
    
    xlabel('$$x$$ [AU]', 'Interpreter', 'latex');
    ylabel('$$y$$ [AU]', 'Interpreter', 'latex');
    zlabel('$$z$$ [AU]', 'Interpreter', 'latex');
    
    grid('on');
    axis('equal');
    
    drawnow;
end
