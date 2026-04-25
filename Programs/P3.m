function P3()
    % Practical 3: Advanced Particle Dynamics Suite
    % A unified, interactive program for simulating time-parametrized, 
    % circular, pendular, and projectile motions.
    
    % Ensure high-quality graphics toolkit is used
    graphics_toolkit('qt');
    
    while true
        fprintf('\n==================================================\n');
        fprintf('       PRACTICAL 3: DYNAMICS SIMULATION SUITE     \n');
        fprintf('==================================================\n');
        fprintf('1. Time-Parametrized Motion (E x B Drift)\n');
        fprintf('2. Circular Motion Kinematics\n');
        fprintf('3. Simple Pendulum Animation & Phase Space\n');
        fprintf('4. Projectile Motion with Aerodynamic Drag\n');
        fprintf('5. Exit Program\n');
        fprintf('==================================================\n');
        
        choice = input('Enter the number of the simulation to run (1-5): ');
        
        switch choice
            case 1
                fprintf('Starting Time-Parametrized Motion...\n');
                sim_parameterized();
            case 2
                fprintf('Starting Circular Motion Simulation...\n');
                sim_circular();
            case 3
                fprintf('Starting Simple Pendulum Animation...\n');
                sim_pendulum();
            case 4
                fprintf('Starting Projectile Motion Simulation...\n');
                sim_projectile();
            case 5
                fprintf('Exiting the Simulation Suite. Goodbye!\n');
                break;
            otherwise
                fprintf('Invalid input. Please enter an integer between 1 and 5.\n');
        end
    end
end

%% --- Local Simulation Functions ---

function sim_parameterized()
    % a) Time parametrized motion of a particle in a plane
    close all;
    omega = 2.0; v_d = 1.5; R = 1.0; 
    t = linspace(0, 4*pi, 500); 
    
    x = v_d * t + R * sin(omega * t);
    y = R * cos(omega * t);
    
    figure('Name', '3(a): Parametrized Motion', 'Color', 'w');
    plot(x, y, 'b-', 'LineWidth', 2); hold on;
    scatter(x(1), y(1), 50, 'g', 'filled'); 
    scatter(x(end), y(end), 50, 'r', 'filled'); 
    title('Parametrized Motion: \vec{E} \times \vec{B} Drift');
    xlabel('x(t)'); ylabel('y(t)');
    legend('Trajectory', 'Start', 'End', 'Location', 'best');
    grid on; axis equal;
end

function sim_circular()
    % b) Simulate a particle executing circular motion
    close all;
    R = 5; omega = 1.0; 
    t = linspace(0, 4*pi, 200); 
    
    figure('Name', '3(b): Circular Motion', 'Color', 'w');
    hold on; axis equal; xlim([-12 12]); ylim([-12 12]); grid on;
    title('Circular Motion: \vec{v} and \vec{a} Vectors');
    
    % Plot the reference orbit
    plot(R*cos(t), R*sin(t), 'k--', 'LineWidth', 1);
    
    % Initialize particle
    h_particle = plot(R, 0, 'mo', 'MarkerSize', 10, 'MarkerFaceColor', 'm');
    
    % Initialize Velocity Vector (Blue line with a dot at the tip)
    h_v_line = plot([R, R], [0, R*omega], 'b-', 'LineWidth', 2);
    h_v_head = plot(R, R*omega, 'bo', 'MarkerSize', 5, 'MarkerFaceColor', 'b');
    
    % Initialize Acceleration Vector (Red line with a dot at the tip)
    h_a_line = plot([R, R-R*omega^2], [0, 0], 'r-', 'LineWidth', 2);
    h_a_head = plot(R-R*omega^2, 0, 'ro', 'MarkerSize', 5, 'MarkerFaceColor', 'r');
    
    % Add legend (ignoring the vector heads for a cleaner legend)
    legend('Orbit', 'Particle', 'Velocity', '', 'Acceleration', '', 'Location', 'northeastoutside');
    
    for i = 1:length(t)
        % Safety check: Break the loop if the user closes the window early
        if ~ishandle(h_particle)
            break;
        end
        
        % Calculate current kinematics
        x_curr = R * cos(omega * t(i)); 
        y_curr = R * sin(omega * t(i));
        
        vx = -R * omega * sin(omega * t(i)); 
        vy = R * omega * cos(omega * t(i));
        
        ax = -R * omega^2 * cos(omega * t(i)); 
        ay = -R * omega^2 * sin(omega * t(i));
        
        % Update particle position
        set(h_particle, 'XData', x_curr, 'YData', y_curr);
        
        % Update Velocity vector (stem and tip)
        set(h_v_line, 'XData', [x_curr, x_curr + vx], 'YData', [y_curr, y_curr + vy]);
        set(h_v_head, 'XData', x_curr + vx, 'YData', y_curr + vy);
        
        % Update Acceleration vector (stem and tip)
        set(h_a_line, 'XData', [x_curr, x_curr + ax], 'YData', [y_curr, y_curr + ay]);
        set(h_a_head, 'XData', x_curr + ax, 'YData', y_curr + ay);
        
        drawnow; 
        pause(0.02);
    end
end

function sim_pendulum()
    % c) Produce the animation of a simple pendulum
    close all;
    g = 9.81; L = 2.0;
    ode_func = @(x, t) [x(2); -(g/L)*sin(x(1))]; 
    t_span = linspace(0, 10, 250);
    [sol] = lsode(ode_func, [pi/3; 0], t_span);
    
    theta = sol(:, 1); omega = sol(:, 2);
    
    figure('Name', '3(c): Pendulum Dynamics', 'Position', [100 100 800 400], 'Color', 'w');
    subplot(1, 2, 1); hold on; axis equal; xlim([-2.5 2.5]); ylim([-2.5 0.5]); grid on;
    title('Physical Space');
    h_line = plot([0, L*sin(theta(1))], [0, -L*cos(theta(1))], 'k-', 'LineWidth', 2);
    h_bob = plot(L*sin(theta(1)), -L*cos(theta(1)), 'ro', 'MarkerSize', 12, 'MarkerFaceColor', 'r');
    
    subplot(1, 2, 2); hold on; grid on;
    title('Phase Space (\theta vs \omega)');
    xlabel('\theta (rad)'); ylabel('\omega (rad/s)');
    xlim([-1.2 1.2]); ylim([-3 3]);
    h_phase = plot(theta(1), omega(1), 'b-', 'LineWidth', 1.5);
    
    for i = 1:length(t_span)
        % Safety check: Break loop if window is closed
        if ~ishandle(h_bob)
            break;
        end
        
        x_pos = L * sin(theta(i)); y_pos = -L * cos(theta(i));
        set(h_line, 'XData', [0, x_pos], 'YData', [0, y_pos]);
        set(h_bob, 'XData', x_pos, 'YData', y_pos);
        set(h_phase, 'XData', theta(1:i), 'YData', omega(1:i));
        drawnow;
        pause(0.02);
    end
end

function sim_projectile()
    % d) Produce the animation of a particle executing projectile motion
    close all;
    g = 9.81; m = 1.0; c = 0.05; v0 = 30; theta0 = pi/4;
    x0 = [0; v0*cos(theta0); 0; v0*sin(theta0)]; 
    
    drag_ode = @(x, t) [x(2); -(c/m)*sqrt(x(2)^2+x(4)^2)*x(2); x(4); -g-(c/m)*sqrt(x(2)^2+x(4)^2)*x(4)];
    ideal_ode = @(x, t) [x(2); 0; x(4); -g];
    
    t_span = linspace(0, 5, 150);
    sol_drag = lsode(drag_ode, x0, t_span);
    sol_ideal = lsode(ideal_ode, x0, t_span);
    
    valid_drag = sol_drag(:, 3) >= 0; valid_ideal = sol_ideal(:, 3) >= 0;
    
    figure('Name', '3(d): Projectile Animation', 'Color', 'w');
    hold on; grid on; title('Projectile Motion: Ideal vs Drag');
    xlabel('Distance (m)'); ylabel('Height (m)');
    xlim([0 max(sol_ideal(valid_ideal, 1)) * 1.1]); ylim([0 max(sol_ideal(valid_ideal, 3)) * 1.2]);
    
    plot(sol_ideal(valid_ideal, 1), sol_ideal(valid_ideal, 3), 'k--', 'LineWidth', 1.5);
    h_path = plot(sol_drag(1, 1), sol_drag(1, 3), 'b-', 'LineWidth', 2);
    h_proj = plot(sol_drag(1, 1), sol_drag(1, 3), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
    legend('Vacuum Trajectory', 'Trajectory with Drag', 'Projectile', 'Location', 'northeast');
    
    for i = 1:sum(valid_drag)
        % Safety check: Break loop if window is closed
        if ~ishandle(h_proj)
            break;
        end
        
        set(h_path, 'XData', sol_drag(1:i, 1), 'YData', sol_drag(1:i, 3));
        set(h_proj, 'XData', sol_drag(i, 1), 'YData', sol_drag(i, 3));
        drawnow; 
        pause(0.02);
    end
end
