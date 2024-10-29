function computeMaterialSizes(filePath)
    % Read the file content
    data = readmatrix('results_cube.txt');
    
    
    % Extract x, y, z coordinates and material (1=water, 2=bone)
    x = data(:, 1);
    y = data(:, 2);
    z = data(:, 3);
    material = data(:, 4);
    
    % Find the coordinates for water and bone
    waterCoords = [x(material == 1), y(material == 1), z(material == 1)];
    boneCoords  = [x(material == 2), y(material == 2), z(material == 2)];
    
    % Compute the extents (sizes) for water in terms of voxels
    if ~isempty(waterCoords)
        waterSizeX = max(waterCoords(:,1)) - min(waterCoords(:,1)) + 1;
        waterSizeY = max(waterCoords(:,2)) - min(waterCoords(:,2)) + 1;
        waterSizeZ = max(waterCoords(:,3)) - min(waterCoords(:,3)) + 1;
        fprintf('Water Dimensions (voxels): X = %.0f, Y = %.0f, Z = %.0f\n', ...
            waterSizeX, waterSizeY, waterSizeZ);
    else
        disp('No water voxels found.');
    end
    
    % Compute the extents (sizes) for bone in terms of voxels
    if ~isempty(boneCoords)
        boneSizeX = max(boneCoords(:,1)) - min(boneCoords(:,1)) + 1;
        boneSizeY = max(boneCoords(:,2)) - min(boneCoords(:,2)) + 1;
        boneSizeZ = max(boneCoords(:,3)) - min(boneCoords(:,3)) + 1;
        fprintf('Bone Dimensions (voxels): X = %.0f, Y = %.0f, Z = %.0f\n', ...
            boneSizeX, boneSizeY, boneSizeZ);
    else
        disp('No bone voxels found.');
    end
end
