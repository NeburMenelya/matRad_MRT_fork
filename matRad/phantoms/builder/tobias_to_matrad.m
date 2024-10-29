function createMatRadPhantomFromFile(filePath)
    % Read the file content
    data = readmatrix('results_cube.txt');
 
    % Extract x, y, z and material (1=water, 2=bone) columns
    x = data(:, 1);
    y = data(:, 2);
    z = data(:, 3);
    material = data(:, 4);

    % Define the dimensions of the CT cube (64x64x64 voxels)
    ctDim = [64, 64, 64];
    voxelSize = 0.0005;  % 0.5 micrometers in mm
    numOfCtScen = 1;

    % Initialize the PhantomBuilder object
    phantomBuilder = matRad_PhantomBuilder(ctDim, [voxelSize, voxelSize, voxelSize], numOfCtScen);

    % Create voxel grid
    cubeHU = ones(ctDim) * -1000;  % Start with background HU (-1000, air)
    
    % Loop through material data and assign HUs based on material type
    for i = 1:length(material)
        if material(i) == 1  % Water
            cubeHU(x(i), y(i), z(i)) = 0; % Water is 0 HU
        elseif material(i) == 2  % Bone
            cubeHU(x(i), y(i), z(i)) = 1000; % Bone is 1000 HU
        end
    end

    % Add water and bone volumes to the PhantomBuilder
    phantomBuilder.addBoxTarget('Water', ctDim, 'HU', 0, 'offset', [0,0,0]);
    phantomBuilder.addBoxTarget('Bone', ctDim, 'HU', 1000, 'offset', [0,0,0]);

    % Get the ct and cst structures from the PhantomBuilder
    [ct, cst] = phantomBuilder.getctcst();
    
    % Update the CT cube with the HU values
    ct.cubeHU{1} = cubeHU;
    
    % Save the resulting CT and CST to a .mat file
    save('../results_cube2.mat', 'ct', 'cst');

    % Output success message
    disp('CT cube and CST structure created and saved to results_cube.mat');
end