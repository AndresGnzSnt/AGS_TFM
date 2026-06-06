%% MAPA 2D DEL COMPRESOR PARA SIMULINK

%% 1) Datos del mapa del compresor

    % Línea 40.000 rpm
    PR_40 = [1.14625895, 1.163664103, 1.174914837, 1.178079844];
    mdot_40_gs = [50.30901337, 39.10236359, 29.86398125, 18.71655273];
    
    % Línea 60.000 rpm
    PR_60 = [1.35305357, 1.401592612, 1.424025655, 1.424699426];
    mdot_60_gs = [79.18011475, 60.12361145, 45.66476440, 28.64409637];
    
    % Línea 80.000 rpm
    PR_80 = [1.686578155, 1.764946103, 1.800610026, 1.832264066];
    mdot_80_gs = [111.8178406, 94.72633362, 77.07083893, 60.93492126];
    
    % Línea 100.000 rpm
    PR_100 = [2.19750309, 2.305735588, 2.384037018, 2.423826456];
    mdot_100_gs = [151.3955383, 130.6853333, 109.9132538, 88.92223358];
    
    % Línea 120.000 rpm
    PR_120 = [2.942045689, 3.11053443, 3.228055954, 3.263905764];
    mdot_120_gs = [201.7102356, 178.4088287, 155.9868469, 132.1966858];

%% 2) Breakpoints de la tabla

    N_bp  = [0 40000 60000 80000 100000 120000];    % [rpm]
    PR_bp = 1.00:0.025:3.50;                        % [-]

%% 3) Generación de las líneas de caudal

    mdot_0_gs = zeros(size(PR_bp));
    
    mdot_40_tab  = crearLineaPR(PR_bp, PR_40,  mdot_40_gs);
    mdot_60_tab  = crearLineaPR(PR_bp, PR_60,  mdot_60_gs);
    mdot_80_tab  = crearLineaPR(PR_bp, PR_80,  mdot_80_gs);
    mdot_100_tab = crearLineaPR(PR_bp, PR_100, mdot_100_gs);
    mdot_120_tab = crearLineaPR(PR_bp, PR_120, mdot_120_gs);

%% 4) Tabla 2D para Simulink

    mdot_table_gs = [mdot_0_gs;mdot_40_tab; mdot_60_tab; ...
        mdot_80_tab; mdot_100_tab; mdot_120_tab];

%% 5) Representación del mapa

    [N_grid, PR_grid] = ndgrid(N_bp, PR_bp);
    
    figure;
    surf(N_grid, PR_grid, mdot_table_gs);
    xlabel('N_{real} [rpm]');
    ylabel('PR [-]');
    zlabel('m_{corr} [g/s]');
    title('Mapa 2D del compresor');
    grid on;
    
    figure;
    plot(PR_bp, mdot_40_tab,  'LineWidth', 1.5); hold on;
    plot(PR_bp, mdot_60_tab,  'LineWidth', 1.5);
    plot(PR_bp, mdot_80_tab,  'LineWidth', 1.5);
    plot(PR_bp, mdot_100_tab, 'LineWidth', 1.5);
    plot(PR_bp, mdot_120_tab, 'LineWidth', 1.5);
    grid on;
    xlabel('PR [-]');
    ylabel('m_{corr} [g/s]');
    title('Líneas del mapa del compresor');
    legend('40 krpm','60 krpm','80 krpm','100 krpm','120 krpm');

%% 6) Guardado de variables

    save('MapaCompresor_2D.mat','N_bp','PR_bp','mdot_table_gs');
    
    disp('MapaCompresor_2D.mat generado correctamente');

%% Función auxiliar

    function mdot_tab = crearLineaPR(PR_bp, PR_line, mdot_line_gs)
    
    mdot_tab = zeros(size(PR_bp));
    
    PR_first = PR_line(1);
    PR_last  = PR_line(end);
    
    mdot_first = mdot_line_gs(1);
    mdot_last  = mdot_line_gs(end);
    
    % Margen para hacer caer el caudal fuera de la zona estable
    PR_margin = 0.12 * (PR_last - 1);
    
    if PR_margin < 0.08
        PR_margin = 0.08;
    end
    
    PR_cut = PR_last + PR_margin;
    
    for i = 1:length(PR_bp)
    
        PR = PR_bp(i);
    
        if PR <= PR_first
    
            mdot_tab(i) = mdot_first;
    
        elseif PR >= PR_cut
    
            mdot_tab(i) = 0;
    
        elseif PR > PR_last
    
            frac = (PR - PR_last) / (PR_cut - PR_last);
            mdot_tab(i) = mdot_last * (1 - frac);
    
        else
    
            mdot_tab(i) = interp1(PR_line, mdot_line_gs, PR, 'linear');
    
        end
    
        if mdot_tab(i) < 0
            mdot_tab(i) = 0;
        end
    
    end
    
    end