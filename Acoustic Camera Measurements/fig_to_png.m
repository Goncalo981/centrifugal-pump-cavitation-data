% MATLAB Script to batch-convert .fig files to .png
clear; clc;

% 1. Define the folder containing your files (leave empty '' if in the current folder)
sourceFolder = ''; 
outputFolder = 'PNG_Outputs'; % Folders where PNGs will be saved

% Create the output folder if it doesn't exist
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% 2. List all the files matching your naming pattern
% Change '*.fig' to match your exact extension if different
filePattern = fullfile(sourceFolder, 's*.fig'); 
dirFiles = dir(filePattern);

if isempty(dirFiles)
    error('No matching files found. Check your file extension or folder path!');
end

fprintf('Found %d files to process.\n', length(dirFiles));

% 3. Loop through each file, open it, and save as PNG
for i = 1:length(dirFiles)
    baseFileName = dirFiles(i).name;
    fullFileName = fullfile(dirFiles(i).folder, baseFileName);
    
    % Extract name without extension for the output file
    [~, nameOnly, ~] = fileparts(baseFileName);
    outputFileName = fullfile(outputFolder, [nameOnly, '.png']);
    
    try
        % Open the figure invisibly so it runs fast in the background
        fig = openfig(fullFileName, 'invisible');
        
        % Save as a high-resolution PNG (300 DPI)
        print(fig, outputFileName, '-dpng', '-r300');
        
        % Close the hidden figure to free up memory
        close(fig);
        
        fprintf('Successfully saved: %s.png\n', nameOnly);
    catch ME
        fprintf('Error processing file %s: %s\n', baseFileName, ME.message);
    end
end

disp('--- All files have been converted successfully! ---');