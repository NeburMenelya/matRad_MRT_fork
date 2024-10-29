function createWaterCubePhantom()
    % Define the dimensions of the water cube in voxels
    cubeDim = [64, 64, 64];  % 64x64x64 voxels

    % Define the voxel size (0.5 mm)
    voxelSize = 0.5;          % Voxel size in mm

    % Initialize the PhantomBuilder object with the cube dimensions and voxel resolution
    phantomBuilder = matRad_PhantomBuilder(cubeDim, [voxelSize, voxelSize, voxelSize], 1);

    % Add water as a target VOI with Hounsfield Units (HU) set to 0
    phantomBuilder.addBoxTarget('Water', cubeDim, 'HU', 0);

    % Get the CT and CST structures from the PhantomBuilder
    [ct, cst] = phantomBuilder.getctcst();

    % Initialize the ct structure
    ct = struct();  % Create an empty structure for CT

    % Create the ct.cube as a 1x1 cell containing the water cube
    ct.cube{1} = zeros(cubeDim);  % Initialize the cube with water (0)

    % Assign cube dimensions
    ct.cubeDim = cubeDim;  % Assign cube dimensions to ct.cubeDim

    % Assign voxel resolution
    ct.resolution.x = voxelSize;  % Voxel size in mm for x
    ct.resolution.y = voxelSize;  % Voxel size in mm for y
    ct.resolution.z = voxelSize;  % Voxel size in mm for z

    % Number of CT scenarios
    ct.numOfCtScen = 1;  % Set number of CT scenarios

    % Assign Hounsfield Units for water
    ct.cubeHU{1} = zeros(size(ct.cube{1}));  % Initialize HU array for the cube
    ct.cubeHU{1}(:) = 0;  % Assign 0 HU for water

    % Save the resulting CT and CST structures to a .mat file
    save('water_cube_phantom.mat', 'ct', 'cst');  % Save the structure to the .mat file

    % Output success message
    disp('MAT file created: water_cube_phantom.mat');
end
