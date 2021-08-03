function DoseRate = matRad_getDoseRate2D_poly(machine,r_mm,thet)
% Calculation of radial dose Rate, interpolating using polynomes
%       2D dose rate formalism from Rivard et al. (2004): AAPM TG-43 update, 
%       page 637, eq. 1
%
% call
%   DoseRate = matRad_getDoseRate2D_poly(machine,r_mm,thet)
%
% input
%   machine: TG43 information about the used seeds
%   r_mm: radial distance array, given in mm!
%   thet: polar angle in degree
%
% output 
%   DoseRate: size(r) array of dose Rate in Gy/s
%
% DIMENSIONS
%   TG43 consensus data   cm, cGy/h
%   matRad                mm, Gy, s
%   output dimensions depend on the dimensions of air kerma strength
%   Sk, normallyi in cGy*cm^2/h)

matRad_cfg = MatRad_Config.instance();

%% validate/ complete input arguments
if ~isfield(machine.data,'AnisotropyRadialDistances')
    matRad_cfg.dispError('machine is missing field "AnisotropyRadialDistances"...you might be trying to apply the TG43 1D formalism for basedata measured for 2D formalism') 
end
if ~isfield(machine.data,'AnisotropyPolarAngles')
    matRad_cfg.dispError('machine is missing field "AnisotropyPolarAngles"')
end
if ~isfield(machine.data,'AnisotropyFunctionValue')
    matRad_cfg.dispError('machine is missing field "AnisotropyFunctionValue"')
end
if ~isfield(machine.data,'lambda')
    matRad_cfg.dispError('machine is missing field "lambda" (dose constant in water)') 
end
if  machine.data.lambda < 0
    matRad_cfg.dispError('negative doseRate')
end
if ~isfield(machine.data,'AnisotropyRadialDistances')
    matRad_cfg.dispError('machine is missing field "AnisotropyRadialDistances"') 
end
if ~isfield(machine.data,'AnisotropyPolarAngles')
    matRad_cfg.dispError('machine is missing field "AnisotropyPolarAngles"')
end
if ~isfield(machine.data,'AnisotropyFunctionValue')
    matRad_cfg.dispError('machine is missing field "AnisotropyFunctionValue"')
end
if min(r_mm,[],'all') < 0
    matRad_cfg.dispError('r contatins negative distances')
end
if ~isfield(machine.data,'ActiveSourceLength')
    matRad_cfg.dispError('machine is missing field "ActiveSourceLength", defining the source length')
end
if ~isfield(machine.data,'SourceStrengthImplanted')
    machine.data.SourceStrengthImplanted = 1;
end 

%% arguments used during function
% r: radius (within this function all radii are given in cm)
r = 0.1*r_mm; 

% Sk: Air-kerma strength in U...[1 U = 1 muGy*m^2/h) = 1 cGy*cm^2/h]
Sk = machine.data.SourceStrengthImplanted;

% lambda: Dose-rate constant in water (Lambda) in cGy/(h*U)
lambda = machine.data.lambda;

% L: length of line source in cm
L = machine.data.ActiveSourceLength;

% r0: standard radius in cm
r0 = 1;

% thet0: standard angle in degree
theta0 = 90;

% gLTab: Tabulated radial dose function \\ cell entry 1: radii; entry 2: values
% radii in cm, values in units of g(r0)
gLTab{1} = machine.data.RadialDoseDistance;
gLTab{2} = machine.data.RadialDoseValue;

% FTab: Tabulated 2D anisotropy function
% \\ cell entry 1: radii; entry 2: angles; entry 3: values
% radii in cm, angles in degree, values unitless
FTab{1} = machine.data.AnisotropyRadialDistances;
FTab{2} = machine.data.AnisotropyPolarAngles;
FTab{3} = machine.data.AnisotropyFunctionValue;

%% 2D formalism
% according to Rivard et al.: AAPM TG-43 update p. 637 eq. (1)
% call interpolate functions and calculate formalism
gL = matRad_radialDoseFunction(r,gLTab);
GL = matRad_geometryFunction(r,thet,L);
GL0 = matRad_geometryFunction(r0,theta0,L);
F = matRad_anisotropyFunction2D(r,thet,FTab);

DoseRate = Sk * lambda * GL./GL0.*gL.*F;
end