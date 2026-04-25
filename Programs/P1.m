function P1()
    % PRACTICAL 1: Master Program
    % Combines RNG (LCG), Monte Carlo Pi Estimation, MC Integration, and Random Walk
    
    graphics_toolkit('qt');
    
    while true
        clc;
        fprintf('\n==================================================\n');
        fprintf('       PRACTICAL 1: MONTE CARLO METHODS SUITE     \n');
        fprintf('==================================================\n');
        fprintf('1. Pseudo-Random Number Generator (LCG Applets)\n');
        fprintf('2. Monte Carlo Estimation of Pi (Hit-or-Miss)\n');
        fprintf('3. Hit-or-Miss Monte Carlo Numerical Integration\n');
        fprintf('4. Monte Carlo 2D Random Walk\n');
        fprintf('5. Exit Program\n');
        fprintf('==================================================\n');
        
        choice = input('Enter the number of the simulation to run (1-5): ');
        
        switch choice
            case 1
                sim_png();
            case 2
                sim_mc_pi();
            case 3
                sim_mc_integration();
            case 4
                sim_random_walk();
            case 5
                fprintf('Exiting Practical 1. Goodbye!\n');
                break;
            otherwise
                fprintf('Invalid input. Please enter an integer between 1 and 5.\n');
                pause(2);
        end
    end
end

%% ============================================================
%  1. PSEUDO-RANDOM NUMBER GENERATOR (LCG)
%  ============================================================
function sim_png()
    close all; clc;
    disp('==== PSEUDO-RANDOM NUMBER GENERATOR (LCG) ====');
    
    params = [
        13,     0,  31,       1;  % Case i
        263,    71, 100,      79; % Case ii
        16807,  0,  2^31 - 1, 1   % Case iii 
    ];
    
    titles = {
        'Case (i): RNG (13, 0, 31, 1)', 
        'Case (ii): RNG (263, 71, 100, 79)', 
        'Case (iii): RNG (16807, 0, 2^{31}-1, 1)'
    };
    
    N = 2500; 
    
    figure('Name', 'P1(a): Random Applet Plots', 'Position', [100, 100, 1200, 400], 'Color', 'w');
    
    for k = 1:3
        a = params(k, 1); c = params(k, 2); m = params(k, 3); seed = params(k, 4);
        
        r = zeros(N, 1);
        curr = double(seed); 
        
        for i = 1:N
            curr = mod(double(a) * curr + double(c), double(m)); 
            r(i) = curr / double(m); 
        end
        
        x = r(1:end-1);
        y = r(2:end);
        
        subplot(1, 3, k);
        plot(x, y, '.', 'MarkerSize', 6, 'Color', [0.1 0.3 0.7]);
        title(titles{k}, 'FontSize', 11);
        xlabel('r_{i}', 'FontSize', 10); ylabel('r_{i+1}', 'FontSize', 10);
        grid on; axis square; xlim([0 1]); ylim([0 1]);
    end
    
    fprintf('\nProgram P1a executed successfully.\n');
    fprintf('Notice how Cases (i) and (ii) form distinct lines (lattices), \n');
    fprintf('whereas Case (iii) fills the space far more uniformly.\n\n');
    
    fprintf('Close the figure window to return to the main menu...\n');
    waitfor(gcf); 
end

%% ============================================================
%  2. MONTE CARLO ESTIMATION OF PI
%  ============================================================
function sim_mc_pi()
    close all; clc;
    disp('==== MONTE CARLO ESTIMATION OF PI (FULL CIRCLE) ====');

    N = input('Enter the number of random points: ');

    if N <= 0 || rem(N,1) ~= 0
        error('Number of points must be a positive integer');
    end

    count_inside = 0;

    fig = figure('Name', 'P1(b): MC Pi Estimation', 'Color', 'w');
    clf; hold on;
    axis([-1 1 -1 1]); axis square;
    xlabel('X Coordinate'); ylabel('Y Coordinate');
    title('Monte Carlo Estimation of \pi using Full Circle');

    theta = linspace(0, 2*pi, 400);
    plot(cos(theta), sin(theta), 'k', 'LineWidth', 2);

    plot_step = max(1, floor(N/5000));

    for i = 1:N
        x = 2*rand() - 1;
        y = 2*rand() - 1;

        if (x^2 + y^2) <= 1
            count_inside = count_inside + 1;
            if mod(i, plot_step) == 0
                plot(x, y, 'b.');
            end
        else
            if mod(i, plot_step) == 0
                plot(x, y, 'r.');
            end
        end
        
        if ~ishandle(fig)
            disp('Figure closed. Stopping simulation...');
            break;
        else 
            drawnow;
        end
    end
    hold off;

    pi_estimate = 4 * count_inside / N;

    fprintf('\n========================================\n');
    fprintf('Total random points      : %d\n', N);
    fprintf('Points inside circle     : %d\n', count_inside);
    fprintf('Estimated value of pi    : %.6f\n', pi_estimate);
    fprintf('Actual value of pi       : %.6f\n', pi);
    fprintf('Absolute error           : %.6e\n', abs(pi - pi_estimate));
    fprintf('========================================\n');

    fprintf('Close the figure window to return to the main menu...\n');
    if ishandle(fig)
        waitfor(fig);
    end
end

%% ============================================================
%  3. MONTE CARLO NUMERICAL INTEGRATION
%  ============================================================
function sim_mc_integration()
    close all; clc;
    disp('==== HIT OR MISS MONTE CARLO INTEGRATION ====');

    a = input('Enter lower limit a = ');
    b = input('Enter upper limit b = ');
    N = input('Enter number of random points N = ');

    disp(' ');
    disp('Choose Function:');
    disp('1. x');
    disp('2. x^2-x+1');
    disp('3. sin^2(x)cos(x)');
    disp('4. (x^2+4x+9)^3(2x+4)');
    disp('5. exp(-x)');
    disp('6. Custom function');

    choice = input('Enter choice number = ');

    switch choice
        case 1
            f = @(x) x;
            func_name = 'x';
        case 2
            f = @(x) x.^2 - x + 1;
            func_name = 'x^2-x+1';
        case 3
            f = @(x) (sin(x).^2) .* cos(x); 
            func_name = 'sin^2(x)cos(x)';
        case 4
            f = @(x) (x.^2 + 4.*x + 9).^3 .* (2.*x + 4);
            func_name = '(x^2+4x+9)^3(2x+4)';
        case 5
            f = @(x) exp(-x);
            func_name = 'exp(-x)';
        case 6
            disp('Enter function in terms of x (example: x.^3 + 2*x)');
            str = input('f(x) = ', 's');
            f = str2func(['@(x) ' str]);
            func_name = str;
        otherwise
            error('Invalid choice');
    end

    x_test = linspace(a, b, 1000);
    f_max = max(f(x_test));

    x_hit = []; y_hit = [];
    x_miss = []; y_miss = [];
    hits = 0;

    for i = 1:N
        x_rand = a + (b-a)*rand();
        y_rand = f_max * rand();
        
        if y_rand <= f(x_rand)
            hits = hits + 1;
            x_hit(end+1) = x_rand;
            y_hit(end+1) = y_rand;
        else
            x_miss(end+1) = x_rand;
            y_miss(end+1) = y_rand;
        end
    end

    area_rectangle = (b-a)*f_max;
    I_est = (hits/N)*area_rectangle;

    fprintf('\nEstimated Integral = %f\n', I_est);

    fig = figure('Name', 'P1(c): MC Integration', 'Color', 'w');
    x_plot = linspace(a,b,1000);
    plot(x_plot, f(x_plot), 'k', 'LineWidth', 2);
    hold on;

    plot(x_hit, y_hit, 'g.');
    plot(x_miss, y_miss, 'r.');
    plot([a b b a a],[0 0 f_max f_max 0],'b--');

    xlabel('x'); ylabel('y');
    title(['Hit-or-Miss MC Integration of ', func_name]);
    legend('f(x)','Hits','Misses','Bounding Rectangle', 'Location', 'northeastoutside');
    grid on;
    
    fprintf('Close the figure window to return to the main menu...\n');
    waitfor(fig);
end

%% ============================================================
%  4. MONTE CARLO 2D RANDOM WALK
%  ============================================================
function sim_random_walk()
    close all; clc;
    disp('==== MONTE CARLO 2D RANDOM WALK ====');

    % Parameters
    N_steps = 1000;   % Number of steps per random walk
    N_trials = 5000;  % Number of Monte Carlo trials
    step_size = 1.0;  % Length of each step

    disp('Running Monte Carlo simulation...');

    % 1. Generate random angles for all steps and all trials simultaneously
    % rand(N_steps, N_trials) creates a matrix of random numbers between 0 and 1
    theta = 2 * pi * rand(N_steps, N_trials);

    % 2. Calculate the x and y displacements for each step
    dx = step_size * cos(theta);
    dy = step_size * sin(theta);

    % 3. Calculate cumulative sum to get absolute (x, y) coordinates
    % We prepend a row of zeros so every walk starts exactly at the origin (0,0)
    X = [zeros(1, N_trials); cumsum(dx)];
    Y = [zeros(1, N_trials); cumsum(dy)];

    % 4. Calculate the final radial distance for each of the N_trials
    % R = sqrt(x^2 + y^2) at the final step (the last row of the matrices)
    R_final = sqrt(X(end, :).^2 + Y(end, :).^2);

    % 5. Estimate average radial distance using the Monte Carlo average
    avg_R = mean(R_final);

    % In a 2D continuous-angle random walk, the theoretical expected value for R
    % is (sqrt(pi)/2) * sqrt(N), not just sqrt(N) (which is the Root Mean Square)
    theoretical_R = (sqrt(pi)/2) * sqrt(N_steps) * step_size;

    fprintf('\n========================================\n');
    fprintf('Monte Carlo Estimated Average R: %.4f\n', avg_R);
    fprintf('Theoretical Expected Average R:  %.4f\n', theoretical_R);
    fprintf('========================================\n');

    % -------------------------------------------------------------------------
    % 2D Visualization
    % -------------------------------------------------------------------------
    fig = figure('Name', 'P1(d): 2D Random Walk', 'Color', 'w');
    hold on;

    % Plot the trajectories of the first 3 trials to avoid cluttering the plot
    plot(X(:, 1), Y(:, 1), 'b-', 'LineWidth', 1.2, 'DisplayName', 'Walk 1');
    plot(X(:, 2), Y(:, 2), 'r-', 'LineWidth', 1.2, 'DisplayName', 'Walk 2');
    plot(X(:, 3), Y(:, 3), 'g-', 'LineWidth', 1.2, 'DisplayName', 'Walk 3');

    % Mark the origin (start point)
    plot(0, 0, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k', 'DisplayName', 'Start (0,0)');

    % Mark the end points of the plotted walks
    plot(X(end, 1:3), Y(end, 1:3), 'kx', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName', 'End Points');

    hold off;
    title(sprintf('2D Random Walk Visualization (%d steps)', N_steps));
    xlabel('X Coordinate');
    ylabel('Y Coordinate');
    legend('Location', 'northeast'); 
    grid on;
    axis equal; % Ensures the spatial scale is the same for x and y
    
    fprintf('Close the figure window to return to the main menu...\n');
    waitfor(fig);
end
