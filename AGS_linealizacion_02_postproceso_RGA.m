%% AGS_linealizacion_02_postproceso_RGA.m
% Postproceso de la planta linealizada y calculo de la RGA

    clc;
    format long e;
    
    disp('POSTPROCESO DE LINEALIZACION Y RGA')

%% 1) Comprobacion de la planta linealizada

    if ~exist('linsys1','var')
        error(['No existe la variable linsys1 en el Workspace. ', ...
               'Primero hay que linealizar el modelo con Model Linearizer.']);
    end

%% 2) Planta exportada desde Model Linearizer

    G_raw = linsys1;
    
    G_raw.InputName  = {'Ncomp_ref','x_SIV'};
    G_raw.OutputName = {'p_pre_bar','m_comp'};
    
    disp('Planta linealizada bruta:')
    disp(G_raw)
    disp(' ')

%% 3) Reordenacion de salidas

    % Salidas:  m_comp, p_pre_bar
    % Entradas: Ncomp_ref, x_SIV
    
    Gd_mimo = G_raw([2 1],[1 2]);
    
    Gd_mimo.InputName  = {'Ncomp_ref','x_SIV'};
    Gd_mimo.OutputName = {'m_comp','p_pre_bar'};
    
    disp('Planta linealizada preparada:')
    disp('Filas:     m_comp, p_pre_bar')
    disp('Columnas: Ncomp_ref, x_SIV')
    disp(' ')

%% 4) Informacion basica de la planta

    Ts = Gd_mimo.Ts;
    
    disp('Planta Gd_mimo:')
    disp(Gd_mimo)
    disp(' ')
    
    disp('Tiempo de muestreo Ts:')
    disp(Ts)
    disp(' ')
    
    disp('Dimensiones de la planta:')
    disp(size(Gd_mimo))
    disp(' ')

%% 5) Matriz de ganancias estaticas

    Klin_mimo = dcgain(Gd_mimo);
    
    disp('Matriz de ganancias estaticas Klin_mimo:')
    disp('Filas:     m_comp, p_pre_bar')
    disp('Columnas: Ncomp_ref, x_SIV')
    disp(Klin_mimo)
    disp(' ')

%% 6) Terminos individuales

    K11 = Klin_mimo(1,1);   % Ncomp_ref -> m_comp
    K12 = Klin_mimo(1,2);   % x_SIV     -> m_comp
    K21 = Klin_mimo(2,1);   % Ncomp_ref -> p_pre_bar
    K22 = Klin_mimo(2,2);   % x_SIV     -> p_pre_bar
    
    disp('Terminos individuales:')
    fprintf('K11 = %.16e   Ncomp_ref -> m_comp\n', K11)
    fprintf('K12 = %.16e   x_SIV     -> m_comp\n', K12)
    fprintf('K21 = %.16e   Ncomp_ref -> p_pre_bar\n', K21)
    fprintf('K22 = %.16e   x_SIV     -> p_pre_bar\n', K22)
    disp(' ')

%% 7) Matriz RGA

    RGA_lin = Klin_mimo .* (inv(Klin_mimo))';
    
    disp('Matriz RGA:')
    disp(RGA_lin)
    disp(' ')
    
    disp('Comprobacion de la RGA:')
    disp('Suma de filas:')
    disp(sum(RGA_lin,2))
    disp('Suma de columnas:')
    disp(sum(RGA_lin,1))
    disp(' ')

%% 8) Guardado de resultados

    if exist('op','var')
        save('AGS_linealizacion_MIMO.mat', ...
             'G_raw', ...
             'Gd_mimo', ...
             'op', ...
             'Klin_mimo', ...
             'RGA_lin', ...
             'K11', 'K12', 'K21', 'K22');
    else
        save('AGS_linealizacion_MIMO.mat', ...
             'G_raw', ...
             'Gd_mimo', ...
             'Klin_mimo', ...
             'RGA_lin', ...
             'K11', 'K12', 'K21', 'K22');
    end
    
    disp('Resultados guardados en AGS_linealizacion_MIMO.mat')
    disp('Postproceso finalizado correctamente.')