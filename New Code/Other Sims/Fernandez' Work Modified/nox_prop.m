function nox_prop = nox_prop()
% Physical properties of Nitrous Oxide
pCrit = 72.51;     % critical pressure, Bar Abs 
rhoCrit = 452.0;   % critical density, kg/m3 
tCrit = 309.57;    % critical temperature, Kelvin (36.42 Centigrade) */
ZCrit = 0.28;      % critical compressibility factor 
gamma = 1.3;       % average over subcritical range 
MolMass = 44.013;  % molecular weight of N2O g/mol
R = 8314.3;        % universal gas constant [J/(kmol*K)]

nox_prop = [pCrit, rhoCrit, tCrit, ZCrit, gamma, MolMass, R];