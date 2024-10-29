function createMatRadPhantomFromFile(filePath)
    % Read the file content
    data = readmatrix('results_cube.txt');
    
    % Extract x, y, z and material (1=water, 2=bone) columns
    x = data(:, 1);
    y = data(:, 2);
    z = data(:, 3);
    material = data(:, 4);

    % Define the dimensions of the CT cube (64x64x64 voxels)
    ctDim = [64, 64, 64];  % 64x64x64 voxels
    ctDim_bone = [44, 44, 44]
    voxelSize = 0.05;    %  in mm
    numOfCtScen = 1;

    % Initialize the PhantomBuilder object with CT dimensions and voxel resolution
    phantomBuilder = matRad_PhantomBuilder(ctDim, [voxelSize, voxelSize, voxelSize], numOfCtScen);

    % Use cube initialized to air (-1000 HU) as background
    cubeHU = ones(ctDim) * -1000;

    % Assign Hounsfield Units (HU) based on the material type: water (0 HU) and bone (1000 HU)
    for i = 1:length(material)
        if material(i) == 1  % Water
            cubeHU(x(i), y(i), z(i)) = 0;    % Water is 0 HU
        elseif material(i) == 2  % Bone
            cubeHU(x(i), y(i), z(i)) = 1000; % Bone is 1000 HU
        end
    end

    % Add a box for the water target using matRad_PhantomVOIBox and PhantomBuilder
    phantomBuilder.addBoxTarget('Water', ctDim, 'HU', 0, 'offset', [0, 0, 0]);

    % Add a box for the bone as an OAR using matRad_PhantomVOIBox and PhantomBuilder
    phantomBuilder.addBoxOAR('Bone', ctDim_bone, 'HU', 1000, 'offset', [0, 0, 0]);

    % Retrieve the updated CT and CST structures from the PhantomBuilder
    [ct, cst] = phantomBuilder.getctcst();

    % Update the CT cube with HU values (apply water and bone HUs)
    ct.cubeHU{1} = cubeHU;

    
    % Save the resulting CT and CST to a .mat file
    save('../results_cube.mat', 'ct', 'cst');
end
