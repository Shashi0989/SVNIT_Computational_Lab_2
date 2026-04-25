% Interference of two identical 2-D waves
% Static fringe pattern for 7 sets of input parameters

% Define 7 sets of input parameters: [lambda, d, D] (All units in mm)
params = [
    0.0005,   0.10, 1000;  % Set 1: Baseline 
    0.0007,   0.10, 1000;  % Set 2: Larger wavelength
    0.0005,   0.20, 1000;  % Set 3: Larger slit gap
    0.0005,   0.10, 2000;  % Set 4: Larger screen distance
    0.0004,   0.05,  500;  % Set 5: Custom mix
    0.000589, 5.00, 3000;  % Set 6: 589nm, d=5mm, D=3m
    0.0002,   2.00,  200   % Set 7: 200nm, d=2mm, D=0.2m
];

% Create the figure window but keep it hidden while drawing to prevent GUI lag/jitter
fig = figure('Position', [50, 50, 1400, 800], 'Name', '2D Wave Interference', 'Visible', 'off');

% Set a balanced resolution
grid_size = 800; 

for i = 1:7
    lambda = params(i, 1);
    d = params(i, 2);
    D = params(i, 3);
    
    % Calculate theoretical fringe width to prevent spatial aliasing (visual jitter)
    fringe_width = (lambda * D) / d;
    
    % Dynamically zoom the screen to show a clear pattern without pixel distortion
    % Capped at +/- 15 mm max so the standard sets look normal
    screen_max = min(15, 20 * fringe_width); 
    
    % Generate the grid for this specific subplot
    [X, Y] = meshgrid(linspace(-screen_max, screen_max, grid_size), ...
                      linspace(-screen_max, screen_max, grid_size));
    
    % Calculate geometric distances
    r1 = sqrt(X.^2 + (Y - d/2).^2 + D^2);
    r2 = sqrt(X.^2 + (Y + d/2).^2 + D^2);
    
    % Calculate path difference and Intensity
    delta_r = abs(r1 - r2);
    I = cos(pi * delta_r / lambda).^2;
    
    % Plot the static interference pattern
    subplot(2, 4, i);
    imagesc([-screen_max screen_max], [-screen_max screen_max], I);
    colormap('gray'); 
    
    % Formatting
    title(sprintf('Set %d:\n\\lambda=%.6f mm\nd=%.2f mm, D=%d mm', i, lambda, d, D));
    xlabel('Screen X (mm)');
    ylabel('Screen Y (mm)');
    axis image;
end

% Reveal the fully drawn figure all at once for a smooth pop-up
set(fig, 'Visible', 'on');
% --- NEW CODE TO SAVE THE FIGURE ---
filename = 'P4.png';
print(fig, filename, '-dpng', '-r300'); % Saves as PNG at 300 DPI
fprintf('Saved high-resolution plot to: %s\\n', fullfile(pwd, filename));
pause;
