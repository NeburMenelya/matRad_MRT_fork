function createPhantomWithBoneAndWater()
    % Define the dimensions of the water cube (in voxels)
    waterDim = [64, 64, 64];  % Dimensions of the water cube in voxels
    % Define the dimensions of the bone cube (in voxels)
    boneDim = [44, 44, 44];    % Dimensions of the bone cube in voxels

    % Define the voxel size (0.5 mm)
    voxelSize = 0.5;           % Voxel size in mm

    % Initialize the PhantomBuilder object with water cube dimensions
    phantomBuilder = matRad_PhantomBuilder(waterDim, [voxelSize, voxelSize, voxelSize], 1);

    % Add water as a target VOI (water is set to 0 HU)
    phantomBuilder.addBoxTarget('Water', waterDim, 'HU', 0);

    % Calculate the offset to center the bone inside the water
    boneOffset = (waterDim - boneDim) / 2;  % Centering the bone cube within the water cube

    % Add bone as an OAR VOI (bone is set to 1000 HU)
    phantomBuilder.addBoxOAR('Bone', boneDim, 'HU', 1000, 'offset', boneOffset);

    % Get the CT and CST structures from the PhantomBuilder
    [~, cst] = phantomBuilder.getctcst();  % Get CST without CT structure

    % Initialize the ct structure
    ct = struct();  % Create an empty structure for CT

    % Initialize the ct.cube with zeros (representing water) in a 1x1 cell
    ct.cube{1} = zeros(waterDim);  % Initialize the cube with water (0)

    % Fill the ct.cube with 1 for the bone region
    % Ensure bone is centered within the water
    ct.cube{1}(boneOffset(1)+(1:boneDim(1)), boneOffset(2)+(1:boneDim(2)), boneOffset(3)+(1:boneDim(3))) = 1;

    % Assign cube dimensions
    ct.cubeDim = waterDim;  % Assign cube dimensions to ct.cubeDim

    % Assign voxel resolution
    ct.resolution.x = voxelSize;  % Voxel size in mm for x
    ct.resolution.y = voxelSize;  % Voxel size in mm for y
    ct.resolution.z = voxelSize;  % Voxel size in mm for z

    % Number of CT scenarios
    ct.numOfCtScen = 1;  % Set number of CT scenarios

    % Assign Hounsfield Units
    ct.cubeHU{1} = zeros(size(ct.cube{1}));  % Initialize HU array for the cube
    for i = 1:numel(ct.cube{1})
        if ct.cube{1}(i) == 1
            ct.cubeHU{1}(i) = 1000; % Assign 1000 HU for bone
        else
            ct.cubeHU{1}(i) = 0;    % Assign 0 HU for water
        end
    end

    % Save the resulting CT and CST structures to a .mat file
    save('phantom_data.mat', 'ct', 'cst');  % Save the structure to the .mat file

    % Output success message
    disp('MAT file created: phantom_data.mat');
end
