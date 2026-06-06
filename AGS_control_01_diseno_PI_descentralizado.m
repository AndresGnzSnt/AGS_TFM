%% AGS_control_01_diseno_PI_descentralizado.m
% Diseño del PI descentralizado del subsistema de aire

clear; close all; clc;
format long e;

disp('DISENO PI DESCENTRALIZADO')
disp(' ')

%% 1) Cargar planta linealizada

load('AGS_linealizacion_MIMO.mat');

% Variables cargadas:
% Gd_mimo -> planta linealizada discreta MIMO 2x2
%
% Orden:
% salidas:  [m_comp ; p_pre_bar]
% entradas: [Ncomp_ref ; x_SIV]

G = Gd_mimo;
Ts = G.Ts;

disp('Planta linealizada cargada correctamente.')
fprintf('Tiempo de muestreo Ts = %.4f s\n', Ts)
disp(' ')

%% 2) Seleccionar canales segun el emparejamiento RGA

% Emparejamiento usado:
% m_comp    <- x_SIV
% p_pre_bar <- Ncomp_ref

G_m_x = G(1,2);   % x_SIV     -> m_comp
G_p_N = G(2,1);   % Ncomp_ref -> p_pre_bar

disp('Canales seleccionados:')
disp('G_m_x = G(1,2)   x_SIV     -> m_comp')
disp('G_p_N = G(2,1)   Ncomp_ref -> p_pre_bar')
disp(' ')

%% 3) Sintonizar controladores PI

C_m = pidtune(G_m_x,'PI');   % PI de caudal
C_p = pidtune(G_p_N,'PI');   % PI de presion

Kp_m = C_m.Kp;
Ki_m = C_m.Ki;

Kp_p = C_p.Kp;
Ki_p = C_p.Ki;

%% 4) Mostrar ganancias finales

disp('Ganancias finales del PI descentralizado:')
fprintf('PI caudal:  Kp_m = %.6f, Ki_m = %.6f\n', Kp_m, Ki_m)
fprintf('PI presion: Kp_p = %.6f, Ki_p = %.6f\n', Kp_p, Ki_p)
disp(' ')

%% 5) Punto nominal y saturaciones usadas en Simulink

xSIV_0  = 0.412;     % [-]
Ncomp_0 = 79000;     % [rpm]

xSIV_min = 0;
xSIV_max = 1;

Ncomp_min = 0;
Ncomp_max = 120000;

disp('Punto nominal:')
fprintf('xSIV_0  = %.3f\n', xSIV_0)
fprintf('Ncomp_0 = %.0f rpm\n', Ncomp_0)
disp(' ')

disp('Saturaciones:')
fprintf('%.1f <= x_SIV <= %.1f\n', xSIV_min, xSIV_max)
fprintf('%.0f <= Ncomp_ref <= %.0f rpm\n', Ncomp_min, Ncomp_max)
disp(' ')

disp('Diseño del PI descentralizado finalizado.')