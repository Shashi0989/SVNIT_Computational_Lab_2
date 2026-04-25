function P6()
    % PRACTICAL 6: Statistical Distributions and Density of States
    % Simulates MB, FD, and BE distributions and their temperature dependence.
    
    graphics_toolkit('qt');
    
    while true
        clc;
        fprintf('\n==================================================\n');
        fprintf('       PRACTICAL 6: STATISTICAL PHYSICS           \n');
        fprintf('==================================================\n');
        fprintf('1. Density of States g(E)\n');
        fprintf('2. Statistical Distributions (MB, FD, BE) [Semilog Scale]\n');
        fprintf('3. Temperature Effect (T = 1K, 100K, 250K)\n');
        fprintf('4. Combined Population Density: f(E) = g(E)n(E) [Semilog Scale] \n');
        fprintf('5. Numerical Computation of Total Particles (N)\n');
        fprintf('6. Exit Program\n');
        fprintf('==================================================\n');
        
        choice = input('Enter the number of the simulation to run (1-6): ');
        
        switch choice
            case 1
                sim_dos();
            case 2
                sim_distributions();
            case 3
                sim_temperature_effect();
            case 4
                sim_population_density();
            case 5
                calc_total_particles();
            case 6
                fprintf('Exiting Practical 6. Goodbye!\n');
                break;
            otherwise
                fprintf('Invalid input. Please enter an integer between 1 and 6.\n');
                pause(2);
        end
    end
end

%% --- GLOBAL CONSTANTS ---
function [k, mu, E] = get_params()
    k = 8.617e-5;                 % Boltzmann constant in eV/K
    mu = 0.5;                     % Chemical potential in eV
    E = linspace(0.3, 0.7, 1000); % Narrow energy range around mu
end

%% ============================================================
%  1. DENSITY OF STATES (DOS)
%  ============================================================
function sim_dos()
    close all; clc;
    E = linspace(0.001, 5, 1000); % Narrow energy range around mu
    
    g_E = sqrt(E);
    
    fig = figure('Name', 'P6.1: Density of States', 'Color', 'w', 'Position', [100, 100, 600, 500]);
    
    plot(E, g_E, 'k-', 'LineWidth', 2);
    title('Density of States g(E) \propto \surd{E}');
    xlabel('Energy (eV)'); ylabel('g(E)');
    grid on;
    
    fprintf('Close the figure window to return to the main menu...\n');
    waitfor(fig);
end

%% ============================================================
%  2. BASIC DISTRIBUTIONS (SEMILOG SCALE)
%  ============================================================
function sim_distributions()
    close all; clc;
    [k, mu, E] = get_params();
    T = 1000; 
    
    n_MB = exp(-(E - mu) ./ (k * T));
    n_FD = 1 ./ (exp((E - mu) ./ (k * T)) + 1);
    
    % BE Distribution with Singularity Masking
    n_BE = 1 ./ (exp((E - mu) ./ (k * T)) - 1);
    n_BE(E <= mu) = NaN; % Physically, E must be > mu for Bosons
    
    fig = figure('Name', 'P6.2: Distributions (Semilog)', 'Color', 'w', 'Position', [100, 100, 700, 500]);
    
    % Use semilogy for the Y-axis to clearly show exponential tails
    semilogy(E, n_MB, 'b-', 'LineWidth', 1.5); hold on;
    semilogy(E, n_FD, 'r-', 'LineWidth', 1.5);
    semilogy(E, n_BE, 'g-', 'LineWidth', 1.5);
    
    % Plot vertical line for chemical potential
    yl = ylim; 
    plot([mu, mu], yl, 'k--', 'LineWidth', 1.2);
    text(mu + 0.01, yl(2)*0.5, '\mu = 0.5 eV', 'FontSize', 10, 'Color', 'k');
    
    title(sprintf('Statistical Distributions at T = %d K (Semilog)', T));
    xlabel('Energy (eV)'); ylabel('Occupation Number n(E) [Log Scale]');
    legend('Maxwell-Boltzmann', 'Fermi-Dirac', 'Bose-Einstein', 'Location', 'best');
    grid on;
    
    fprintf('Close the figure window to return to the main menu...\n');
    waitfor(fig);
end

%% ============================================================
%  3. TEMPERATURE EFFECTS (COMPARING DISTRIBUTIONS PER TEMP)
%  ============================================================
function sim_temperature_effect()
    close all; clc;
    [k, mu, E] = get_params();
    T_vals = [1, 250, 1000]; 
    
    fig = figure('Name', 'P6.3: Distributions vs Temperature', 'Color', 'w', 'Position', [100, 100, 1200, 400]);
    
    % Define strict visual boundaries to prevent Octave overflow
    ymin = 1e-4;
    ymax = 10;
    
    for i = 1:length(T_vals)
        T = T_vals(i);
        subplot(1, 3, i); 
        hold on; 
        
        % 1. Maxwell-Boltzmann (Blue)
        n_MB = exp(-(E - mu) ./ (k * T));
        n_MB(~isfinite(n_MB)) = ymax;
        n_MB = max(min(n_MB, ymax), ymin);
        plot(E, n_MB, 'b-', 'LineWidth', 1.5);
        
        % 2. Fermi-Dirac (Red)
        n_FD = 1 ./ (exp((E - mu) ./ (k * T)) + 1);
        n_FD(~isfinite(n_FD)) = ymax; 
        n_FD = max(min(n_FD, ymax), ymin); 
        plot(E, n_FD, 'r-', 'LineWidth', 1.5);
        
        % 3. Bose-Einstein (Green)
        n_BE = 1 ./ (exp((E - mu) ./ (k * T)) - 1);
        n_BE(E <= mu) = ymin; % Mask unphysical states
        n_BE(~isfinite(n_BE)) = ymax; 
        n_BE = max(min(n_BE, ymax), ymin);
        plot(E, n_BE, 'g-', 'LineWidth', 1.5);
        
        % Format the axes safely for log scale
        set(gca, 'YScale', 'log');
        ylim([ymin, ymax]); 
        plot([mu, mu], [ymin, ymax], 'k--'); % Chemical potential line
        
        % Aesthetics and Labels
        title(sprintf('Temperature: T = %d K', T));
        xlabel('Energy (eV)'); 
        if i == 1
            ylabel('Occupation Number n(E) [Log]'); 
        end
        grid on; 
        legend('MB', 'FD', 'BE', '\mu', 'Location', 'northeast');
    end
    
    fprintf('Close the figure window to return to the main menu...\n');
    waitfor(fig);
end

%% ============================================================
%  4. COMBINED POPULATION DENSITY f(E)
%  ============================================================
function sim_population_density()
    close all; clc;
    [k, mu, E] = get_params();
    T = 1000;
    
    g_E = sqrt(E);
    f_MB = g_E .* exp(-(E - mu) ./ (k * T));
    f_FD = g_E .* (1 ./ (exp((E - mu) ./ (k * T)) + 1));
    
    f_BE = g_E .* (1 ./ (exp((E - mu) ./ (k * T)) - 1));
    f_BE(E <= mu) = NaN; % Mask unphysical/singular states
    
    fig = figure('Name', 'P6.4: Population Density f(E)', 'Color', 'w', 'Position', [100, 100, 700, 500]);
    
    semilogy(E, f_MB, 'b-', 'LineWidth', 1.5); hold on;
    semilogy(E, f_FD, 'r-', 'LineWidth', 1.5);
    semilogy(E, f_BE, 'g-', 'LineWidth', 1.5);
    
    yl = ylim;
    semilogy([mu, mu], yl, 'k--', 'LineWidth', 1.2);
    text(mu + 0.01, yl(2)*0.9, '\mu = 0.5 eV', 'FontSize', 10, 'Color', 'k');
    
    title(sprintf('Population Density f(E) = g(E)n(E) at T = %d K', T));
    xlabel('Energy (eV)'); ylabel('f(E)');
    legend('MB Population', 'FD Population', 'BE Population', 'Location', 'northeast');
    grid on; 
    
    fprintf('Close the figure window to return to the main menu...\n');
    waitfor(fig);
end

%% ============================================================
%  5. NUMERICAL INTEGRATION FOR TOTAL PARTICLES
%  ============================================================
function calc_total_particles()
    clc;
    [k, mu, E] = get_params();
    T = 1000; 
    
    g_E = sqrt(E);
    f_MB = g_E .* exp(-(E - mu) ./ (k * T));
    f_FD = g_E .* (1 ./ (exp((E - mu) ./ (k * T)) + 1));
    
    % Isolate valid physical domain for Bose-Einstein
    valid_BE = E > mu;
    f_BE = g_E(valid_BE) .* (1 ./ (exp((E(valid_BE) - mu) ./ (k * T)) - 1));
    
    % Integrate using Trapezoidal rule
    N_MB = trapz(E, f_MB);
    N_FD = trapz(E, f_FD);
    N_BE = trapz(E(valid_BE), f_BE);
    
    fprintf('--- NUMERICAL INTEGRATION RESULTS (T = %d K) ---\n', T);
    fprintf('Total Particles (Maxwell-Boltzmann): %.4e\n', N_MB);
    fprintf('Total Particles (Fermi-Dirac):       %.4f\n', N_FD);
    fprintf('Total Particles (Bose-Einstein):     %.4f\n', N_BE);
    fprintf('-------------------------------------------------\n');
    fprintf('*Note: The Bose-Einstein distribution diverges at E = mu.\n');
    fprintf(' The integration was strictly evaluated over the physical domain (E > mu)\n');
    fprintf(' to compute the non-condensate particle count.\n');
    fprintf('-------------------------------------------------\n');
    
    fprintf('\nPress ENTER to return to the main menu...\n');
    pause;
end
