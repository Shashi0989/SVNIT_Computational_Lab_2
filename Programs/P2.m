% PH408: Practical 2 - Master Solar System (Complete Legend)
clear all; close all; clc;

% --- Configuration ---
if (ismember('qt', available_graphics_toolkits()))
    graphics_toolkit('qt');
elseif (ismember('fltk', available_graphics_toolkits()))
    graphics_toolkit('fltk');
end

% Create Main Figure
fig = figure('Color', [0.05 0.05 0.05], 'Name', 'Solar System Master Simulation', ...
             'NumberTitle', 'off', 'Position', [50, 50, 1300, 750]);

% --- 1. Define Planetary Data ---
% [Name, Semi-Major Axis (a), Eccentricity (e), Size, Color]
planets = {
    'Mercury', 0.6,  0.50,  4,  [0.8 0.8 0.8]; 
    'Venus',   1.1,  0.01,  6,  [0.9 0.7 0.2]; 
    'Earth',   1.8,  0.02,  7,  [0.2 0.5 1.0]; 
    'Mars',    2.5,  0.20,  5,  [1.0 0.3 0.1]; 
    'Jupiter', 4.0,  0.05,  12, [0.8 0.6 0.5];
    'Saturn',  5.5,  0.06,  10, [0.9 0.8 0.6];
    'Neptune', 7.0,  0.01,  9,  [0.3 0.3 1.0];
};

% --- 2. Build Detailed Legend Panel ---
uipanel('Title', 'Planetary Orbital Data', 'FontSize', 11, ...
        'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', 'w', ...
        'Position', [0.70 0.1 0.28 0.8]);

% Headers
header_y = 0.83;
col_pos = [0.71, 0.76, 0.805, 0.85, 0.895, 0.94];
headers = {'Planet', 'a (AU)', 'Ecc (e)', 'Peri (q)', 'Aph (Q)', 'V(avg)'};

for k = 1:length(headers)
    uicontrol('Style', 'text', 'String', headers{k}, ...
              'Units', 'normalized', 'Position', [col_pos(k) header_y 0.04 0.03], ...
              'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [0.7 0.7 0.7], ...
              'FontWeight', 'bold', 'FontSize', 8);
end

% Data Rows
start_y = 0.78; step_y = 0.055;
for i = 1:size(planets, 1)
    y_pos = start_y - (i-1)*step_y;
    a = planets{i, 2}; e = planets{i, 3};
    
    % Physics Calculations
    r_peri = a * (1 - e);
    r_aph  = a * (1 + e);
    v_mean = 1 / sqrt(a);
    
    uicontrol('Style', 'text', 'String', '', 'Units', 'normalized', 'Position', [0.705 y_pos+0.005 0.005 0.02], 'BackgroundColor', planets{i, 5});
    uicontrol('Style', 'text', 'String', planets{i, 1}, 'Units', 'normalized', 'Position', [0.715 y_pos 0.045 0.025], 'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', 'w', 'HorizontalAlignment', 'left');
    uicontrol('Style', 'text', 'String', sprintf('%.1f', a), 'Units', 'normalized', 'Position', [0.76 y_pos 0.04 0.025], 'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', 'c');
    uicontrol('Style', 'text', 'String', sprintf('%.2f', e), 'Units', 'normalized', 'Position', [0.805 y_pos 0.04 0.025], 'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', 'y');
    uicontrol('Style', 'text', 'String', sprintf('%.2f', r_peri), 'Units', 'normalized', 'Position', [0.85 y_pos 0.04 0.025], 'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [0.6 1.0 0.6]);
    uicontrol('Style', 'text', 'String', sprintf('%.2f', r_aph), 'Units', 'normalized', 'Position', [0.895 y_pos 0.04 0.025], 'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1.0 0.6 0.6]);
    uicontrol('Style', 'text', 'String', sprintf('%.2f', v_mean), 'Units', 'normalized', 'Position', [0.94 y_pos 0.04 0.025], 'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', 'w');
end

% Extra Info (Special Objects)
y_pos = y_pos - step_y * 1.5;
uicontrol('Style', 'text', 'String', 'Physics Modules:', 'Units', 'normalized', 'Position', [0.71 y_pos 0.2 0.03], ...
          'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', 'w', 'HorizontalAlignment', 'left', 'FontWeight', 'bold');
uicontrol('Style', 'text', 'String', 'Mercury GR Precession: ON', 'Units', 'normalized', 'Position', [0.71 y_pos-0.03 0.2 0.025], ...
          'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [0.8 0.8 0.8], 'HorizontalAlignment', 'left');
          
uicontrol('Style', 'text', 'String', 'Special Objects:', 'Units', 'normalized', 'Position', [0.71 y_pos-0.08 0.2 0.03], ...
          'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', 'w', 'HorizontalAlignment', 'left', 'FontWeight', 'bold');

% Moon Legend Item
uicontrol('Style', 'text', 'String', '', 'Units', 'normalized', 'Position', [0.71 y_pos-0.11 0.005 0.02], 'BackgroundColor', [0.9 0.9 0.9]);
uicontrol('Style', 'text', 'String', 'The Moon (Earth Orbit)', 'Units', 'normalized', 'Position', [0.72 y_pos-0.115 0.2 0.025], ...
          'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [0.9 0.9 0.9], 'HorizontalAlignment', 'left');

% Comet Legend Item
uicontrol('Style', 'text', 'String', '', 'Units', 'normalized', 'Position', [0.71 y_pos-0.14 0.005 0.02], 'BackgroundColor', 'c');
uicontrol('Style', 'text', 'String', 'Halley''s Comet (e=0.85)', 'Units', 'normalized', 'Position', [0.72 y_pos-0.145 0.2 0.025], ...
          'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', 'c', 'HorizontalAlignment', 'left');


% --- 3. Controls ---
h_speed_label = uicontrol('Style', 'text', 'String', 'Speed', 'Units', 'normalized', 'Position', [0.02 0.92 0.05 0.04], ...
    'BackgroundColor', 'k', 'ForegroundColor', 'w');
h_slider = uicontrol('Style', 'slider', 'Min', 0.01, 'Max', 0.15, 'Value', 0.05, ...
    'Units', 'normalized', 'Position', [0.08 0.93 0.15 0.04], 'BackgroundColor', [0.2 0.2 0.2]);

global is_paused; is_paused = false;
h_pause = uicontrol('Style', 'togglebutton', 'String', 'Pause', 'Units', 'normalized', 'Position', [0.25 0.93 0.08 0.04], ...
    'Callback', 'global is_paused; is_paused = not(is_paused);', 'BackgroundColor', [0.8 0.2 0.2], 'ForegroundColor', 'w');

% --- 4. Simulation Arena ---
axes('Position', [0.0 0.0 0.70 1.0], 'Color', 'k');
hold on; axis equal; 
axis([-9.5 9.5 -9.5 9.5]); % Fixed Limits
axis off;

% Starfield
plot((rand(1,300)-0.5)*20, (rand(1,300)-0.5)*20, '.', 'Color', [0.7 0.7 0.7], 'MarkerSize', 1);

% Draw Sun (Reduced Size)
plot(0, 0, 'o', 'MarkerSize', 10, 'MarkerFaceColor', [1 0.5 0], 'MarkerEdgeColor', 'none');
plot(0, 0, 'o', 'MarkerSize', 18, 'MarkerFaceColor', [1 1 0], 'MarkerEdgeColor', 'none', 'Color', [1 1 0]); 

% --- 5. Initialize Objects ---
h_planets = zeros(1, size(planets, 1)); 
h_trails = zeros(1, size(planets, 1));
h_orbits = zeros(1, size(planets, 1)); 
trail_len = 50; 
hist_x = zeros(size(planets,1), trail_len);
hist_y = zeros(size(planets,1), trail_len);
theta_curr = rand(1, size(planets,1)) * 2 * pi; 

mercury_precession = 0; 

for i = 1:size(planets, 1)
    a = planets{i, 2}; e = planets{i, 3};
    % Initial Orbit Path
    th_plot = linspace(0, 2*pi, 300);
    r_plot = (a * (1 - e^2)) ./ (1 + e * cos(th_plot));
    h_orbits(i) = plot(r_plot .* cos(th_plot), r_plot .* sin(th_plot), '-', 'Color', [0.15 0.15 0.15]);
    
    h_trails(i) = plot(NaN, NaN, '-', 'Color', planets{i, 5}, 'LineWidth', 1);
    h_planets(i) = plot(0, 0, 'o', 'MarkerSize', planets{i, 4}, 'MarkerFaceColor', planets{i, 5}, 'MarkerEdgeColor', 'none');
end

% Moon Setup
orbit_radius_moon = 0.3; theta_moon = 0;
h_moon = plot(0, 0, '.', 'MarkerSize', 6, 'Color', [0.9 0.9 0.9]);
h_moon_trail = plot(NaN, NaN, '-', 'Color', [0.5 0.5 0.5], 'LineWidth', 0.5);
moon_hist_x = zeros(1, 20); moon_hist_y = zeros(1, 20);

% Comet Setup
a_comet = 5.5; e_comet = 0.85; theta_comet = pi; 
h_comet = plot(0, 0, 'o', 'MarkerSize', 3, 'MarkerFaceColor', 'c', 'MarkerEdgeColor', 'none');
h_comet_trail = plot(NaN, NaN, '-', 'Color', 'c', 'LineWidth', 1);
comet_hist_x = zeros(1, 60); comet_hist_y = zeros(1, 60);
% Comet Path
th_plot = linspace(0, 2*pi, 300);
r_plot = (a_comet * (1 - e_comet^2)) ./ (1 + e_comet * cos(th_plot));
rot_ang = pi/4; 
plot(r_plot.*cos(th_plot)*cos(rot_ang)-r_plot.*sin(th_plot)*sin(rot_ang), ...
     r_plot.*cos(th_plot)*sin(rot_ang)+r_plot.*sin(th_plot)*cos(rot_ang), '--', 'Color', [0 0.3 0.3]);

% --- 6. Main Loop ---
while ishandle(fig)
    if is_paused, pause(0.1); continue; end
    dt = get(h_slider, 'Value');
    
    earth_pos = [0, 0]; 
    for i = 1:size(planets, 1)
        a = planets{i, 2}; e = planets{i, 3};
        
        % 1. Standard Kepler Physics
        r = (a * (1 - e^2)) / (1 + e * cos(theta_curr(i)));
        theta_curr(i) = theta_curr(i) + (dt * 1.5 * sqrt(a) / r^2);
        px = r * cos(theta_curr(i)); py = r * sin(theta_curr(i));
        
        % 2. Apply GR Precession (Mercury Only)
        if strcmp(planets{i,1}, 'Mercury')
            mercury_precession = mercury_precession + (dt * 0.4); 
            
            % Rotate Planet
            x_rot = px * cos(mercury_precession) - py * sin(mercury_precession);
            y_rot = px * sin(mercury_precession) + py * cos(mercury_precession);
            px = x_rot; py = y_rot;
            
            % Rotate Orbit Line
            th_orb = linspace(0, 2*pi, 200);
            r_orb = (a * (1 - e^2)) ./ (1 + e * cos(th_orb));
            x_orb_raw = r_orb .* cos(th_orb); y_orb_raw = r_orb .* sin(th_orb);
            x_orb_rot = x_orb_raw * cos(mercury_precession) - y_orb_raw * sin(mercury_precession);
            y_orb_rot = x_orb_raw * sin(mercury_precession) + y_orb_raw * cos(mercury_precession);
            set(h_orbits(i), 'XData', x_orb_rot, 'YData', y_orb_rot, 'Color', [0.3 0.3 0.3]);
        end
        
        if strcmp(planets{i,1}, 'Earth'), earth_pos = [px, py]; end
        
        set(h_planets(i), 'XData', px, 'YData', py);
        hist_x(i, 1:end-1) = hist_x(i, 2:end); hist_x(i, end) = px;
        hist_y(i, 1:end-1) = hist_y(i, 2:end); hist_y(i, end) = py;
        set(h_trails(i), 'XData', hist_x(i,:), 'YData', hist_y(i,:));
    end
    
    % Moon Update
    theta_moon = theta_moon + dt * 10; 
    mx = earth_pos(1) + orbit_radius_moon * cos(theta_moon);
    my = earth_pos(2) + orbit_radius_moon * sin(theta_moon);
    set(h_moon, 'XData', mx, 'YData', my);
    moon_hist_x(1:end-1) = moon_hist_x(2:end); moon_hist_x(end) = mx;
    moon_hist_y(1:end-1) = moon_hist_y(2:end); moon_hist_y(end) = my;
    set(h_moon_trail, 'XData', moon_hist_x, 'YData', moon_hist_y);
    
    % Comet Update
    r_c = (a_comet * (1 - e_comet^2)) ./ (1 + e_comet * cos(theta_comet));
    theta_comet = theta_comet + (dt * 2.0 * sqrt(a_comet) / r_c^2);
    cx_raw = r_c * cos(theta_comet); cy_raw = r_c * sin(theta_comet);
    cx = cx_raw * cos(rot_ang) - cy_raw * sin(rot_ang);
    cy = cx_raw * sin(rot_ang) + cy_raw * cos(rot_ang);
    set(h_comet, 'XData', cx, 'YData', cy);
    comet_hist_x(1:end-1) = comet_hist_x(2:end); comet_hist_x(end) = cx;
    comet_hist_y(1:end-1) = comet_hist_y(2:end); comet_hist_y(end) = cy;
    set(h_comet_trail, 'XData', comet_hist_x, 'YData', comet_hist_y);
    
    drawnow;
end
