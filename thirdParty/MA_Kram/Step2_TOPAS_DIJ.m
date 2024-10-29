%% Step 2: Load TOPAS-Dij
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

patient_nr = '9';
patient_id = 'fake';
ct_id = 'real'; 

% load patient data and configuration
load(['D:/Patients/' patient_nr '/CT_'  ct_id  '_generic.mat']);
load(['D:/Patients/' patient_nr '/STF_' ct_id  '_generic.mat']);
load(['D:/Patients/' patient_nr '/PLN_' ct_id  '_generic.mat']);
load(['D:/Patients/' patient_nr '/CST_' ct_id  '_generic.mat']);

%% Dij
dij_mode = 'topasCalc';

switch dij_mode
    case 'genericLoad'
        load(['D:/Patients/' patient_nr '/DIJ_' ct_id  '_generic.mat']);
        disp('dij mode: generic load');
    
    case 'topasLoad'
        load(['D:/Patients/' patient_nr '/DIJ_' ct_id  '_TOPAS.mat']);
        disp('dij mode: topas load');

    case 'topasCalc'
        load(['D:/Patients/' patient_nr '/DIJ_' ct_id  '_generic.mat']);
        disp('dij mode: topas calc');

        total_x = dij.doseGrid.dimensions(1);
        total_y = dij.doseGrid.dimensions(2);
        
        folderPath = ['D:/Patients/' patient_nr];

        dij.physicalDose{1,1} = [];

        for j = 1:dij.numOfBeams
            if stf(j).totalNumOfBixels ~= 1
                for i = 1:stf(j).totalNumOfBixels
                    
                    file = ['score_field' num2str(j)  '_run' num2str(i) '.csv'];
        
                    % Pfad zur CSV-Datei
                    filePath = fullfile(folderPath, file);
                    
                    % CSV-Datei einlesen
                    topas_Dij = readmatrix(filePath,'Delimiter',',');
                     
                    topas_Dij = [topas_Dij(:,2) + topas_Dij(:,1) * total_x + topas_Dij(:,3) * total_x * total_y, topas_Dij(:,4)*11.2647]; %ignore this factor
                    
                    sortedMatrix = sortrows(topas_Dij, 1);
                    
                    dij_column = sortedMatrix(:,2);
                    
                    dij.physicalDose{1,1} = [dij.physicalDose{1,1}, sparse(dij_column)];
                    disp(i);
                end
            else
                file = ['score_field' num2str(j) '_E71.csv'];
        
                % Pfad zur CSV-Datei
                filePath = fullfile(folderPath, file);
                
                % CSV-Datei einlesen
                topas_Dij = readmatrix(filePath,'Delimiter',',');
                
                topas_Dij = [topas_Dij(:,2) + topas_Dij(:,1) * total_x + topas_Dij(:,3) * total_x * total_y, topas_Dij(:,4)*11.2647]; %ignore this factor
                
                sortedMatrix = sortrows(topas_Dij, 1);
                
                dij_column = sortedMatrix(:,2);
                
                dij.physicalDose{1,1} = [dij.physicalDose{1,1}, sparse(dij_column)];
            end
        end

        % csv files can be deleted. TOPAS Dij is saved as a sparse .mat file
        save(['D:/Patients/' patient_nr '/DIJ_' ct_id  '_TOPAS.mat'], "dij");
end

disp('Finish!');

%% Optimization
resultGUI = matRad_calcCubes(ones(dij.totalNumOfBixels,1),dij); %Use uniform weights

%% GUI
matRadGUI