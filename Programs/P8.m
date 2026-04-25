function P8()
    % PRACTICAL 8: Hadron Substructure & Quark-Parton Model
    % Simulates Parton Distribution Functions (PDFs), Deep Inelastic 
    % Scattering kinematics, and the Callan-Gross relation.
    
    graphics_toolkit('qt');
    
    while true
        clc;
        fprintf('\n==================================================\n');
        fprintf('   PRACTICAL 8: HADRON SUBSTRUCTURE & QPM SUITE   \n');
        fprintf('==================================================\n');
        fprintf('1. Parton Distribution Functions (Valence vs. Sea)\n');
        fprintf('2. Callan-Gross Relation (Proof of Spin-1/2 Quarks)\n');
        fprintf('3. DGLAP Scale Evolution (Toy Model Scaling Violation)\n');
        fprintf('4. Exit Program\n');
        fprintf('==================================================\n');
        
        choice = input('Enter the number of the simulation to run (1-4): ');
        
        switch choice
            case 1
                sim_pdfs();
            case 2
                sim_callan_gross();
            case 3
                sim_dglap_evolution();
            case 4
                fprintf('Exiting Practical 8. Best of luck with your HEP computations!\n');
                break;
            otherwise
                fprintf('Invalid input. Please enter an integer between 1 and 4.\n');
                pause(2);
        end
    end
end

%% ============================================================
%  1. PARTON DISTRIBUTION FUNCTIONS (PDFs)
%  ============================================================
function sim_pdfs()
    close all; clc;
    fprintf('Plotting Toy Parton Distribution Functions at low Q^2...\n');
    
    % Momentum fraction x
    x = logspace(-3, 0, 500); 
    
    % Toy PDF parameterizations (x * f(x)) at Q^2 ~ 1 GeV^2
    % Valence quarks dominate at high x, Sea/Gluons dominate at low x
    x_uv = 2.5 * (x.^0.5) .* ((1 - x).^3);    % Up valence
    x_dv = 1.5 * (x.^0.5) .* ((1 - x).^4);    % Down valence
    x_sea = 0.8 * (1 - x).^7;                 % Sea quarks (q_bar)
    x_gluon = 3.0 * (1 - x).^5;               % Gluons
    
    fig = figure('Name', 'P8.1: Proton PDFs', 'Position', [100, 100, 800, 500], 'Color', 'w');
    hold on;
    
    plot(x, x_uv, 'r-', 'LineWidth', 2);
    plot(x, x_dv, 'b-', 'LineWidth', 2);
    plot(x, x_sea, 'g--', 'LineWidth', 2);
    plot(x, x_gluon, 'k-.', 'LineWidth', 2);
    
    set(gca, 'XScale', 'log');
    title('Parton Distribution Functions inside the Proton', 'FontSize', 14);
    xlabel('Momentum Fraction (x)');
    ylabel('Momentum Density x \cdot f(x)');
    legend('u_v(x) (Up Valence)', 'd_v(x) (Down Valence)', 'S(x) (Sea Quarks)', 'g(x) (Gluons)', 'Location', 'northeast');
    grid on;
    xlim([1e-3, 1]); ylim([0, 3.5]);
    
    fprintf('Close the figure window to return to the main menu...\n');
    waitfor(fig);
end

%% ============================================================
%  2. CALLAN-GROSS RELATION (SPIN-1/2 PROOF)
%  ============================================================
function sim_callan_gross()
    close all; clc;
    fprintf('Verifying the Callan-Gross Relation...\n');
    
    x = linspace(0.01, 1, 200);
    
    % Model the F2 structure function (electromagnetic coupling)
    % F2(x) = x * sum( e_i^2 * q_i(x) )
    e_u = 2/3;
    e_d = -1/3;
    
    q_u = 2.5 * (x.^-0.5) .* ((1 - x).^3); 
    q_d = 1.5 * (x.^-0.5) .* ((1 - x).^4); 
    
    F2 = x .* (e_u^2 * q_u + e_d^2 * q_d);
    
    % Callan-Gross predicts F2(x) = 2x * F1(x) for spin-1/2 partons.
    % We add slight numerical noise to F1 to simulate experimental DIS data
    F1 = (F2 ./ (2 * x)) .* (1 + 0.05 * randn(1, length(x)));
    
    fig = figure('Name', 'P8.2: Callan-Gross Relation', 'Position', [100, 100, 800, 500], 'Color', 'w');
    hold on;
    
    % Plot theoretical F2
    plot(x, F2, 'k-', 'LineWidth', 2);
    
    % Plot "Experimental" 2x*F1
    plot(x, 2 * x .* F1, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 5);
    
    title('Callan-Gross Relation: F_2(x) = 2x F_1(x)', 'FontSize', 14);
    xlabel('Bjorken Scaling Variable (x)');
    ylabel('Structure Functions');
    legend('Theoretical F_2(x)', 'Simulated DIS Data (2x F_1)', 'Location', 'northeast');
    text(0.4, max(F2)*0.8, 'Overlap proves Partons are Spin-1/2 Fermions', 'FontSize', 12, 'Color', 'b');
    grid on;
    
    fprintf('Close the figure window to return to the main menu...\n');
    waitfor(fig);
end

%% ============================================================
%  3. DGLAP EVOLUTION (SCALING VIOLATION)
%  ============================================================
function sim_dglap_evolution()
    close all; clc;
    fprintf('Simulating Scaling Violations (DGLAP Evolution)...\n');
    
    x = logspace(-3, 0, 500); 
    
    % Low Energy Scale (Q^2 = 1 GeV^2)
    F2_lowQ = 1.0 * (x.^0.5) .* ((1 - x).^3) + 0.2 * (1 - x).^7;
    
    % High Energy Scale (Q^2 = 10,000 GeV^2)
    % DGLAP evolution causes gluon splitting: depletion at high x, massive rise at low x
    F2_highQ = 0.8 * (x.^0.6) .* ((1 - x).^4) + 1.5 * (1 - x).^12;
    
    fig = figure('Name', 'P8.3: DGLAP Scaling Violation', 'Position', [100, 100, 800, 500], 'Color', 'w');
    hold on;
    
    plot(x, F2_lowQ, 'b-', 'LineWidth', 2);
    plot(x, F2_highQ, 'r--', 'LineWidth', 2);
    
    set(gca, 'XScale', 'log');
    title('Scaling Violation in Structure Function F_2(x, Q^2)', 'FontSize', 14);
    xlabel('Bjorken x');
    ylabel('Structure Function F_2');
    legend('Low Q^2 (\sim 1 GeV^2)', 'High Q^2 (\sim 10^4 GeV^2)', 'Location', 'northeast');
    
    % Annotations explaining the physics
    text(2e-3, 1.2, '\leftarrow Gluon Splitting (Rise at low x)', 'Color', 'r', 'FontSize', 11);
    text(1e-1, 0.4, 'Valence Depletion \rightarrow', 'Color', 'b', 'FontSize', 11);
    
    grid on;
    xlim([1e-3, 1]);
    
    fprintf('Close the figure window to return to the main menu...\n');
    waitfor(fig);
end
