function P5()
    % PRACTICAL 5: Gravitational Physics Suite
    % Visualizes spacetime curvature and gravitational waves
    
    graphics_toolkit('qt');
    
    while true
        clc;
        fprintf('\n==================================================\n');
        fprintf('       PRACTICAL 5: GRAVITATIONAL PHYSICS         \n');
        fprintf('==================================================\n');
        fprintf('1. Gravitational Dip (Non-Pulsating Body)\n');
        fprintf('2. Gravitational Waves (Pulsating Body Animation)\n');
        fprintf('3. Exit Program\n');
        fprintf('==================================================\n');
        
        choice = input('Enter the number of the simulation to run (1-3): ');
        
        switch choice
            case 1
                sim_static_dip();
            case 2
                sim_grav_waves();
            case 3
                fprintf('Exiting Practical 5. Goodbye!\n');
                break;
            otherwise
                fprintf('Invalid input. Please enter an integer between 1 and 3.\n');
                pause(2);
        end
    end
end

%% ============================================================
%  1. GRAVITATIONAL DIP (AESTHETIC POLAR WIREFRAME)
%  ============================================================
function sim_static_dip()
    close all; clc;
    fprintf('Rendering aesthetic polar gravitational dip...\n');
    
    % 1. High-Resolution Polar Grid
    r = linspace(0, 15, 45);       % More rings for a smoother sweep
    theta = linspace(0, 2*pi, 90); % 90 slices for perfectly round circles
    [R, Theta] = meshgrid(r, theta);
    
    % Convert to Cartesian
    X = R .* cos(Theta);
    Y = R .* sin(Theta);
    
    % 2. Spacetime distortion
    Z = -25 ./ sqrt(R.^2 + 6); 
    
    % Setup "Deep Space" Figure
    fig = figure('Name', 'P5(a): Aesthetic Spacetime', 'Color', 'k', 'Position', [100, 100, 900, 700]);
    
    % 3. Render the Spacetime Fabric
    % Using a very dark navy FaceColor allows the lighting to create a gradient 
    % fade on the fabric, while the cyan EdgeColor keeps the mathematical grid look.
    surf(X, Y, Z, 'FaceColor', [0.0 0.02 0.08], 'EdgeColor', [0.1 0.5 0.9], 'LineWidth', 0.5);
    hold on; 
    
    % --- ADD THE STAR (MASSIVE BODY) ---
    [sx, sy, sz] = sphere(60); % Ultra-smooth sphere
    p_radius = 3.8;              
    p_z_center = -1.2;         % Nestled perfectly in the funnel
    
    % Scale and translate the sphere
    sx = sx * p_radius;
    sy = sy * p_radius;
    sz = (sz * p_radius) + p_z_center;
    
    % Render the Massive Body (Glowing Sun Aesthetic)
    % High ambient strength makes it look self-illuminating (glowing).
    % Low specular prevents it from looking like a glossy plastic/metal ball.
    surf(sx, sy, sz, 'FaceColor', [1.0 0.9 0.1], 'EdgeColor', 'none', ...
         'AmbientStrength', 1.0, ... 
         'DiffuseStrength', 0.8, ...
         'SpecularStrength', 0.1, ...
         'SpecularExponent', 10);
    % --------------------------------------
    
    % 4. Cinematic Lighting Setup
    % Light 1: Emanates directly from the star to illuminate the funnel
    light('Position', [0 0 p_z_center], 'Style', 'local', 'Color', [1.0 0.8 0.4]);
    
    % Light 2: Soft, dim overhead blue light to reveal the outer edges of the grid
    light('Position', [0 0 20], 'Style', 'local', 'Color', [0.1 0.2 0.4]);
    lighting gouraud;
    
    % 5. Camera & Polish
    view(35, 18); % Low cinematic angle
    title('Spacetime Curvature', 'Color', 'w', 'FontSize', 16, 'FontWeight', 'bold');
    
    % Hide axes for a pure floating-in-space aesthetic
    axis([-15 15 -15 15 -12 6]);
    axis off; 
    
    hold off;
    
    fprintf('Close the figure window to return to the main menu...\n');
    waitfor(fig);
end

%% ============================================================
%  2. GRAVITATIONAL WAVES (PULSATING)
%  ============================================================
function sim_grav_waves()
    close all; clc;
    fprintf('Starting gravitational wave animation...\n');
    
    grid_lim = 10;
    [X, Y] = meshgrid(linspace(-grid_lim, grid_lim, 150));
    R = sqrt(X.^2 + Y.^2) + 0.8;
    
    fig = figure('Name', 'P5(b): Gravitational Waves', 'Color', 'k', 'Position', [100, 100, 800, 600]);
    
    % Initial static base
    Z_base = -4 ./ R;
    h_surf = surf(X, Y, Z_base);
    shading interp; 
    colormap('cool');
    
    light('Position', [0 0 10], 'Style', 'local');
    lighting gouraud;
    view(30, 45);
    
    title('Gravitational Waves: Pulsating Mass', 'Color', 'w', 'FontSize', 14);
    set(gca, 'Color', 'k', 'XColor', 'w', 'YColor', 'w', 'ZColor', 'w', 'GridColor', [0.3 0.3 0.3]);
    axis([-grid_lim grid_lim -grid_lim grid_lim -6 2]);
    
    % Wave parameters
    k = 2.5;      % Wave number
    omega = 0.3;  % Angular frequency
    A = 3.0;      % Amplitude of the pulsation
    
    t = 0;
    dt = 0.5;
    
    while true
        % Safety check: break if the user closes the window
        if ~ishandle(h_surf)
            break;
        end
        
        % Calculate Z with an outward traveling wave perturbation: sin(kr - wt) / r
        Z_wave = Z_base + (A .* sin(k .* R - omega .* t) ./ R);
        
        % Update the surface
        set(h_surf, 'ZData', Z_wave);
        drawnow;
        
        t = t + dt;
        pause(0.02);
    end
end
