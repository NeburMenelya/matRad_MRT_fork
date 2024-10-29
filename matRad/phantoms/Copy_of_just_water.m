function createBoneCubePhantom()
    % Define the dimensions of the bone cube in voxels
    cubeDim = [64, 64, 64];  % 64x64x64 voxels

    % Define the voxel size (0.5 mm)
    voxelSize = 0.5;          % Voxel size in mm

    % Initialize the PhantomBuilder object with the cube dimensions and voxel resolution
    phantomBuilder = matRad_PhantomBuilder(cubeDim, [voxelSize, voxelSize, voxelSize], 1);

    % Add bone as an OAR VOI with Hounsfield Units (HU) set to 1000
    phantomBuilder.addBoxOAR('Bone', cubeDim, 'HU', 1000);

    % Get the CT and CST structures from the PhantomBuilder
    [ct, cst] = phantomBuilder.getctcst();

    % Initialize the ct structure
    ct = struct();  % Create an empty structure for CT

    % Create the ct.cube as a 1x1 cell containing the bone cube
    ct.cube{1} = ones(cubeDim);  % Initialize the cube with bone (1)

    % Assign cube dimensions
    ct.cubeDim = cubeDim;  % Assign cube dimensions to ct.cubeDim

    % Assign voxel resolution
    ct.resolution.x = voxelSize;  % Voxel size in mm for x
    ct.resolution.y = voxelSize;  % Voxel size in mm for y
    ct.resolution.z = voxelSize;  % Voxel size in mm for z

    % Number of CT scenarios
    ct.numOfCtScen = 1;  % Set number of CT scenarios

    % Assign Hounsfield Units for bone
    ct.cubeHU{1} = ones(size(ct.cube{1})) * 1000;  % Initialize HU array for the cube with 1000 HU for bone

    % Save the resulting CT and CST structures to a .mat file
    save('bone_cube_phantom.mat', 'ct', 'cst');  % Save the structure to the .mat file

    % Output success message
    disp('MAT file created: bone_cube_phantom.mat');
end
