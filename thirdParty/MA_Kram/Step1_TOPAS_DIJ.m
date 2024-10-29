%% Step 1: Generate TOPAS Parameterfile for Dij-Calculation
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright 2017 the matRad development team. 
% 
% This file is part of the matRad project. It is subject to the license 
% terms in the LICENSE file found in the top-level directory of this 
% distribution and at https://github.com/e0404/matRad/LICENSES.txt. No part 
% of the matRad project, including this file, may be copied, modified, 
% propagated, or distributed except according to the terms contained in the 
% LICENSE file.
%
% Modified by Cihangir Ali Cakir
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% In this File we will...
% (i) 
% (ii) 
% (iii) 

%% set matRad runtime configuration
matRad_rc; % If this throws an error, run it from the parent directory first to set the paths

%% Patient Data Import
% Let's begin with a clear Matlab environment and import the prostate
% patient into your workspace

%patient_nr = '9';
%patient_id = '2_04_P';
%ct_id = 'real';

%load(['D:/Patients/' patient_nr '/' patient_id '_' ct_id '.mat']);

%% Objectives for OAR and TARGET

%for i = 1:size(cst, 1)
%    if strcmp(cst{i, 2}, 'Rectum')
%        cst{i, 3}                        = 'OAR';
%        cst{i, 5}.Priority               = 1;
%        cst{i, 6}{1, 1}.className        = 'DoseObjectives.matRad_MaxDVH';
%        cst{i, 6}{1, 1}.parameters{1, 1} = 2; 
%        cst{i, 6}{1, 1}.parameters{1, 2} = 60;
%        cst{i, 6}{1, 1}.penalty          = 1000;
%    end
%end

%for i = 1:size(cst, 1)
%    if strcmp(cst{i, 2}, 'Urinary bladder')
%        cst{i, 3}                        = 'OAR';
%        cst{i, 5}.Priority               = 1;
%        cst{i, 6}{1, 1}.className        = 'DoseObjectives.matRad_MaxDVH';
%        cst{i, 6}{1, 1}.parameters{1, 1} = 1; 
%        cst{i, 6}{1, 1}.parameters{1, 2} = 50;
%        cst{i, 6}{1, 1}.penalty          = 1000;
%    end
%end

%for i = 1:size(cst, 1)
%    if strcmp(cst{i, 2}, 'Femoral head L')
%        cst{i, 3}                        = 'OAR';
%        cst{i, 5}.Priority               = 2;
%        cst{i, 6}{1, 1}.className        = 'DoseObjectives.matRad_MaxDVH';
%        cst{i, 6}{1, 1}.parameters{1, 1} = 35; 
%        cst{i, 6}{1, 1}.parameters{1, 2} = 5;
%        cst{i, 6}{1, 1}.penalty          = 100;
%    end
%end

%for i = 1:size(cst, 1)
%    if strcmp(cst{i, 2}, 'Femoral head R')
%        cst{i, 3}                        = 'OAR';
%        cst{i, 5}.Priority               = 2;
%        cst{i, 6}{1, 1}.className        = 'DoseObjectives.matRad_MaxDVH';
%        cst{i, 6}{1, 1}.parameters{1, 1} = 35; 
%        cst{i, 6}{1, 1}.parameters{1, 2} = 5;
%        cst{i, 6}{1, 1}.penalty          = 100;
%    end
%end

%for i = 1:size(cst, 1)
%    if strcmp(cst{i, 2}, 'External')
%        cst{i, 3}                        = 'OAR';
%        cst{i, 5}.Priority               = 2;
%        cst{i, 6}{1, 1}.className        = 'DoseObjectives.matRad_MaxDVH';
%        cst{i, 6}{1, 1}.parameters{1, 1} = 61; % verschriebene Dosis in Gy
%        cst{i, 6}{1, 1}.parameters{1, 2} = 0;
%        cst{i, 6}{1, 1}.penalty          = 10000;
%    end
%end

%for i = 1:size(cst, 1)
%    if strcmp(cst{i, 2}, 'Prostate')
%        cst{i, 3}                        = 'TARGET';
%        cst{i, 5}.Priority               = 2;
%        cst{i, 6}{1, 1}.className        = 'DoseObjectives.matRad_MinDVH';
%        cst{i, 6}{1, 1}.parameters{1, 1} = 60; % verschriebene Dosis in Gy
%        cst{i, 6}{1, 1}.parameters{1, 2} = 100;
%        cst{i, 6}{1, 1}.penalty          = 3000;
%    end
%end

%% Treatment Plan
% The next step is to define your treatment plan labeled as 'pln'. This 
% structure requires input from the treatment planner and defines the most 
% important cornerstones of your treatment plan.

%%
% meta information for treatment plan
pln.radiationMode   = 'protons';
pln.machine         = 'GENERIC';

%%
% for particles it is possible to also calculate the LET disutribution
% alongside the physical dose. Therefore you need to activate the
% corresponding option during dose calculcation
pln.propDoseCalc.calcLET = 0;

%%
% Now we have to set the remaining plan parameters.
pln.numOfFractions                  = 1;
pln.propStf.bixelWidth              = 5; % [mm] / also corresponds to lateral spot spacing for particles
pln.propStf.longitudinalSpotSpacing = 3; % [mm]
pln.propStf.gantryAngles            = [90,270]; % [°]
pln.propStf.couchAngles             = [0,0]; % [°] 
pln.propStf.numOfBeams              = numel(pln.propStf.gantryAngles);
pln.propStf.isoCenter               = ones(pln.propStf.numOfBeams,1) * matRad_getIsoCenter(cst,ct,0);
pln.propStf.isoCenter               = pln.propStf.isoCenter + [0, -25, 0];
pln.propOpt.runDAO                  = 0;
pln.propOpt.runSequencing           = 0;

% Turn on to correct for nozzle-to-skin air WEPL in analytical calculation
pln.propDoseCalc.airOffsetCorrection = true;

% Biology
quantityOpt    = 'RBExD';         % either  physicalDose / effect / RBExD
modelName      = 'constRBE';      % none: for photons, protons, carbon                                    
                                  % constRBE: constant RBE model
                                  % MCN: McNamara-variable RBE model for protons                          
                                  % WED: Wedenberg-variable RBE model for protons 
                                  % LEM: Local Effect Model for carbon ions

% retrieve bio model parameters
pln.bioParam = matRad_bioModel(pln.radiationMode,quantityOpt, modelName);

% retrieve scenarios for dose calculation and optimziation
pln.multScen = matRad_multScen(ct,'nomScen');

% dose calculation settings
pln.propDoseCalc.doseGrid.resolution.x = 2; % [mm]
pln.propDoseCalc.doseGrid.resolution.y = 2; % [mm]
pln.propDoseCalc.doseGrid.resolution.z = 2; % [mm]

% optimization settings
pln.propOpt.optimizer       = 'IPOPT';

TOPAS_EXPORT = true;

%%
if TOPAS_EXPORT == true
    % select Monte Carlo engine 
    pln.propMC.engine = 'TOPAS';
    
    % Enable/Disable local computation with TOPAS. Enabling this will generate
    % the necessary TOPAS files to run the simulation on any machine or server.
    pln.propMC.externalCalculation = true;
end

%% Generate Beam Geometry STF
stf = matRad_generateStf(ct,cst,pln);
%stf = matRad_generateSingleBixelStf(ct,cst,pln);

%% Analytical Dose Calculation
% Lets generate dosimetric information by pre-computing dose influence 
% matrices for unit beamlet intensities. Having dose influences available 
% allows for subsequent inverse optimization. 
dij = matRad_calcParticleDose(ct,stf,pln,cst);
%dij = matRad_calcDoseInfluence(ct,cst,stf,pln)
% resultGUI = matRad_fluenceOptimization(dij,cst,pln); %Optimize

%% Monte Carlo Dose Calculation By Creating Export Files For TOPAS MC
if TOPAS_EXPORT == true
    pln.propMC.numHistories = 1e5 * dij.totalNumOfBixels;
    resultGUI               = matRad_calcCubes(ones(dij.totalNumOfBixels,1),dij); % Use uniform weights
    resultGUI_MC            = matRad_fluenceOptimization(dij,cst,pln);
end

%% Saving Configuration for Step 2
% save(['D:/Patients/' patient_nr '/CT_'  ct_id  '_generic.mat'], "ct");
% save(['D:/Patients/' patient_nr '/STF_' ct_id  '_generic.mat'], "stf");
% save(['D:/Patients/' patient_nr '/PLN_' ct_id  '_generic.mat'], "pln");
% save(['D:/Patients/' patient_nr '/CST_' ct_id  '_generic.mat'], "cst"); 
% save(['D:/Patients/' patient_nr '/DIJ_' ct_id  '_generic.mat'], "dij");

%% GUI
%matRadGUI