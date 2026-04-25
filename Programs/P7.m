function P7()
    % PRACTICAL 7: Advanced Strain Engineering
    % Calculates Deformation Potential, Elastic Modulus, Effective Mass,
    % and Acoustic Phonon-Limited Carrier Mobility.
    
    close all; clc;
    filename = 'DFT_data.csv'; 
    fprintf('Reading DFT data from %s...\n', filename);

    % --- READ DATA ---
    try
        data = dlmread(filename, ',', 1, 0);
    catch
        fprintf('ERROR: Could not find "%s".\n', filename);
        return;
    end

    % Extract Columns
    strain = data(:, 1)';
    energy = data(:, 2)';
    VBM    = data(:, 5)';
    CBM    = data(:, 6)';
    K_VBM  = data(:, 8)';
    E_VBM  = data(:, 9)';
    K_CBM  = data(:, 11)';
    E_CBM  = data(:, 12)';

    % --- PHYSICS CALCULATIONS ---
    
    % 1. Deformation Potential (Linear fit of band edges vs strain)
    p_VBM = polyfit(strain, VBM, 1);
    p_CBM = polyfit(strain, CBM, 1);
    Ed_VBM = p_VBM(1);
    Ed_CBM = p_CBM(1);

    % 2. Elastic Modulus (Quadratic fit of Strain Energy)
    p_energy = polyfit(strain, energy, 2);
    elastic_modulus_factor = 2 * p_energy(1); % 2nd derivative (eV)

    % 3. Effective Mass (From E vs K parabolic fit)
    p_CBM_K = polyfit(K_CBM, E_CBM, 2);
    p_VBM_K = polyfit(K_VBM, E_VBM, 2);
    
    % Calculate effective mass (Assuming K in 1/A, hbar^2/2m0 = 3.81)
    m_eff_e = 3.81 / p_CBM_K(1);
    m_eff_h = 3.81 / p_VBM_K(1); % Will be negative for holes
    
    % 4. Carrier Mobility (Deformation Potential Theory)
    % Physical Constants
    T = 300;               % Temperature (K)
    e_charge = 1.602e-19;  % Elementary charge (C)
    hbar = 1.054e-34;      % Reduced Planck constant (J.s)
    kB = 1.380e-23;        % Boltzmann constant (J/K)
    m0 = 9.109e-31;        % Electron rest mass (kg)
    
    % **IMPORTANT**: Update A_0 to the actual unit cell area of your material!
    A_0 = 11.72e-20;          % Assumed Unit Cell Area (m^2) e.g., 15 Angstrom^2

    % Convert extracted parameters to SI Units
    C2D_si = elastic_modulus_factor * e_charge / A_0; % J/m^2
    Ed_e_si = Ed_CBM * e_charge; % J
    Ed_h_si = Ed_VBM * e_charge; % J
    me_si = abs(m_eff_e) * m0;   % kg
    mh_si = abs(m_eff_h) * m0;   % kg

    % Calculate Mobility (m^2 / V.s)
    mu_e_si = (e_charge * hbar^3 * C2D_si) / (kB * T * me_si^2 * Ed_e_si^2);
    mu_h_si = (e_charge * hbar^3 * C2D_si) / (kB * T * mh_si^2 * Ed_h_si^2);

    % Convert to standard condensed matter units (cm^2 / V.s)
    mu_e_cm = mu_e_si * 10000;
    mu_h_cm = mu_h_si * 10000;

    % --- PLOTTING ---
    figure('Name', 'P7: Advanced DFT Derived Properties', 'Position', [100, 100, 1000, 800]);

    % PLOT 1: Deformation Potential (VBM & CBM)
    subplot(2, 2, 1);
    plot(strain, CBM, 'bo', strain, polyval(p_CBM, strain), 'b-', 'LineWidth', 1.5);
    hold on;
    plot(strain, VBM, 'ro', strain, polyval(p_VBM, strain), 'r-', 'LineWidth', 1.5);
    title('Deformation Potential (Linear Fit)');
    xlabel('Strain \epsilon'); ylabel('Energy (eV)');
    legend('CBM Data', sprintf('E_{d,CB} = %.2f eV', Ed_CBM), ...
           'VBM Data', sprintf('E_{d,VB} = %.2f eV', Ed_VBM), 'Location', 'northeast');
    grid on;

    % PLOT 2: 2D Elastic Modulus (Strain Energy Curvature)
    subplot(2, 2, 2);
    plot(strain, energy, 'ko', strain, polyval(p_energy, strain), 'k-', 'LineWidth', 1.5);
    title('2D Elastic Modulus (Quadratic Fit)');
    xlabel('Strain \epsilon'); ylabel('Strain Energy \Delta E (eV)');
    text(min(strain)+0.01, max(energy)*0.8, sprintf('C_{2D} \\approx %.2f eV', elastic_modulus_factor), 'FontSize', 12, 'Color', 'r');
    legend('DFT Energy', 'Parabolic Fit', 'Location', 'north');
    grid on;

    % PLOT 3: E vs K for Conduction Band (Electron Effective Mass)
    subplot(2, 2, 3);
    plot(K_CBM, E_CBM, 'bo', 'MarkerFaceColor', 'b', 'markersize', 4); hold on;
    k_c_dense = linspace(min(K_CBM), max(K_CBM), 50);
    plot(k_c_dense, polyval(p_CBM_K, k_c_dense), 'b-', 'LineWidth', 1.5);
    title('Conduction Band (E vs K)');
    xlabel('Wavevector K (\AA^{-1})'); ylabel('Energy (eV)');
    legend('CBM Data', sprintf('m^*_e \\approx %.2f m_0', m_eff_e), 'Location', 'northeast');
    grid on;

    % PLOT 4: E vs K for Valence Band (Hole Effective Mass)
    subplot(2, 2, 4);
    plot(K_VBM, E_VBM, 'ro', 'MarkerFaceColor', 'r', 'markersize', 4); hold on;
    k_v_dense = linspace(min(K_VBM), max(K_VBM), 50);
    plot(k_v_dense, polyval(p_VBM_K, k_v_dense), 'r-', 'LineWidth', 1.5);
    title('Valence Band (E vs K)');
    xlabel('Wavevector K (\AA^{-1})'); ylabel('Energy (eV)');
    legend('VBM Data', sprintf('m^*_h \\approx %.2f m_0', m_eff_h), 'Location', 'northeast');
    grid on;

    % --- TERMINAL OUTPUT ---
    disp('Physics extraction complete. Review plots for constants.');
    
    fprintf('\n==================================================\n');
    fprintf('       FINAL EXTRACTED PHYSICS PARAMETERS         \n');
    fprintf('==================================================\n');
    fprintf('Deformation Potential (CBM): %8.4f eV\n', Ed_CBM);
    fprintf('Deformation Potential (VBM): %8.4f eV\n', Ed_VBM);
    fprintf('2D Elastic Modulus Factor:   %8.4f eV\n', elastic_modulus_factor);
    fprintf('Effective Mass (Electron):   %8.4f m_0\n', m_eff_e);
    fprintf('Effective Mass (Hole):       %8.4f m_0\n', m_eff_h);
    fprintf('--------------------------------------------------\n');
    fprintf('Acoustic Phonon-Limited Mobility (T = %d K)\n', T);
    fprintf('Electron Mobility (mu_e):    %8.2f cm^2 / V.s\n', mu_e_cm);
    fprintf('Hole Mobility (mu_h):        %8.2f cm^2 / V.s\n', mu_h_cm);
    fprintf('==================================================\n');
    fprintf('*Note: Mobility assumes a unit cell area of %.1f Angstrom^2.\n\n', A_0 * 1e20);
    
    pause;
end
