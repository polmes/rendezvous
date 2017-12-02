function solarSystem = readDatabase(database)
    data = load(database);
    
    % Returns table of planetary data [orbit, mu, radius]
    % 1: Mercury, 2: Venus, ..., 9:Pluto
    solarSystem = data.solarSystem;
end
