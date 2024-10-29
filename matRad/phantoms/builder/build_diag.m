function createPhantomWithBoneAndWater()
    % Define the dimensions of the water cube (20 mm)
    waterDim = [64, 64, 64];  % Water cube dimensions in mm
    % Define the dimensions of the bone cube (10 mm)
    boneDim = [44, 44, 44];    % Bone cube dimensions in mm

    % Define the voxel size (0.5 mm = 500 micrometers)
    voxelSize = 0.5;           % Voxel size in mm
    % Calculate the number of voxels for each dimension
    waterVoxels = waterDim / voxelSize;  % Water cube dimensions in voxels
    boneVoxels = boneDim / voxelSize;    % Bone cube dimensions in voxels

    % Initialize the PhantomBuilder object with CT dimensions and voxel resolution
    phantomBuilder = matRad_PhantomBuilder(waterVoxels, [voxelSize, voxelSize, voxelSize], 1);

    % Add water as a target VOI
    phantomBuilder.addBoxTarget('Water', waterVoxels, 'HU', 0);

    % Calculate the offset to center the bone inside the water
    boneOffset = (waterVoxels - boneVoxels) / 2;  % Centering the bone cube within the water cube

    % Add bone as an OAR VOI
    phantomBuilder.addBoxOAR('Bone', boneVoxels, 'HU', 1000, 'offset', boneOffset);

    % Get the CT and CST structures from the PhantomBuilder
    [ct, cst] = phantomBuilder.getctcst();

    % Save the resulting CT and CST structures to a .mat file
    save('1phantom_data.mat', 'ct', 'cst');

    % Output success message
    disp('MAT file created: phantom_data.mat');
end
