function solarSystem = readDatabase(database)
    data = load(database);
    
    % solarSystem = Orbit.empty(0, size(data, 1));
    % Will return array of orbits (ordered from Mercury to Pluto)
    solarSystem = data;
end
