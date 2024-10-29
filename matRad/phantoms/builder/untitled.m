function visualizeVoxelData(filePath)
    % Read the file content
    data = readmatrix('results_cube.txt');
    
    % Extract x, y, z coordinates and material (1=water, 2=bone)
    x = data(:, 1);
    y = data(:, 2);
    z = data(:, 3);
    material = data(:, 4);

    % Set up colors for water and bone
    waterColor = [0, 0, 1];  % Blue
    boneColor = [1, 0, 0];   % Red
    
    % Create a figure for the 3D visualization
    figure;
    hold on;

    % Scatter plot for water and bone
    scatter3(x(material == 1), y(material == 1), z(material == 1), ...
             10, waterColor, 'filled');  % Water points
    scatter3(x(material == 2), y(material == 2), z(material == 2), ...
             10, boneColor, 'filled');   % Bone points

    % Set axis properties for better visualization
    axis equal;
    xlabel('X (mm)');
    ylabel('Y (mm)');
    zlabel('Z (mm)');
    title('3D Visualization of Voxel Data');
    grid on;
    view(3);  % Set a 3D view
    hold off;
end