%% PARAMETROS DEL MODELO PARA SIMULINK
    %% 1) Ambiente y propiedades del aire
    R_air = 287;          % [J/(kg*K)]  Constante específica del aire
    T_air = 298.15;       % [K]         Temperatura asumida en el volumen equivalente
    T_amb = 298.15;       % [K]         Temperatura ambiente
    p_amb = 101325;       % [Pa]        Presión ambiente
    
    %% 2) Condiciones de referencia para variables corregidas
    p_ref = 101325;       % [Pa]        Presión de referencia
    T_ref = 288.15;       % [K]         Temperatura de referencia
    
    %% 3) Volumen equivalente
    V_eq = 0.01664;       % [m^3]       Volumen equivalente total
    m0   = p_amb * V_eq / (R_air * T_air);   % [kg] Masa inicial de aire en el volumen
    
    %% 4) Parámetros del stack
    N_cells   = 359;      % [-]         Número de celdas
    M_O2      = 0.032;    % [kg/mol]    Masa molar del oxígeno
    F         = 96485;    % [C/mol]     Constante de Faraday
    Y_O2_air  = 0.232;    % [-]         Fracción másica de oxígeno en el aire
    lambda_air = 1.80;    % [-]         Estequiometría del aire recomendada por fabricante
    
    % Consumo de aire por Faraday
    k_Faraday_air = N_cells * M_O2 / (4 * F * Y_O2_air);   % [kg/(s*A)]
    k_air         = k_Faraday_air;                         % [kg/(s*A)] Ganancia  Simulink
    
    % Referencia de caudal
    k_mref = lambda_air * k_Faraday_air;                  % [kg/(s*A)]
    
    % Pérdida de carga del stack
    k_stack = 1.56e6;     % [Pa / (kg/s)^2]
    
    %% 5) Parámetros de la válvula SIV
    k_valve_max = 4e-4;    % [kg/(s*sqrt(Pa))] Capacidad máxima de descarga
    
    %% 6) Parámetros del compresor
    tau_N      = 2.0 / 2.303;  % [s]        Constante de tiempo de la dinámica de velocidad
    N_max      = 120000;       % [rpm]      Velocidad máxima
    PR_max_max = 3.20;         % [-]        Relación de presiones máxima
    m_corr_max = 0.200;        % [kg/s]     Caudal corregido máximo
    
    % Parámetros de ajuste del mapa simplificado
    beta_N   = 1.00;           % [-]
    gamma_PR = 1.80;           % [-]
    alpha_map = 1.40;          % [-]
    
    %% 7) Protecciones numéricas
    Nn_switch_th      = 1e-4;  % [-]  Umbral mínimo de velocidad normalizada para forzar caudal nulo