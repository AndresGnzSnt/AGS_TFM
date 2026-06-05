%% AGS_control_02_diseno_desacoplo_estatico_normalizado.m
% Calculo de la matriz de desacoplo normalizado y de los PI virtuales

clear; close all; clc;

%% 1) Cargar planta linealizada

load('AGS_linealizacion_MIMO.mat');

% Variables cargadas:
% Gd_mimo    -> planta linealizada discreta MIMO 2x2
% Klin_mimo -> matriz de ganancias estaticas
%
% Orden:
% salidas:  [m_comp ; p_pre_bar]
% entradas: [Ncomp_ref ; x_SIV]

G = Gd_mimo;
K = Klin_mimo;

%% 2) Escalas de normalizacion

m_s = 0.01;     % [kg/s]
p_s = 0.1;      % [bar]
N_s = 5000;     % [rpm]
x_s = 0.05;     % [-]

Sy = diag([m_s, p_s]);
Su = diag([N_s, x_s]);

%% 3) Matriz de ganancias normalizada

Kn = inv(Sy) * K * Su;

%% 4) Matriz de desacoplo normalizada

Dn = inv(Kn);

%% 5) Planta normalizada y desacoplada

Gn = inv(Sy) * G * Su;
Gdec = Gn * Dn;

%% 6) Canales diagonales para los PI virtuales

Gm_dec = Gdec(1,1);   % canal virtual de caudal
Gp_dec = Gdec(2,2);   % canal virtual de presion

%% 7) Sintonia de los PI virtuales

C_m = pidtune(Gm_dec, 'PI');
C_p = pidtune(Gp_dec, 'PI');

Kp_m = C_m.Kp;
Ki_m = C_m.Ki;

Kp_p = C_p.Kp;
Ki_p = C_p.Ki;

%% 8) Mostrar resultados

disp('Matriz de ganancias normalizada Kn:')
disp(Kn)

disp('Matriz de desacoplo normalizada Dn:')
disp(Dn)

disp(' ')
disp('Ganancias del PI virtual de caudal:')
fprintf('Kp_m = %.6f\n', Kp_m);
fprintf('Ki_m = %.6f\n', Ki_m);

disp(' ')
disp('Ganancias del PI virtual de presion:')
fprintf('Kp_p = %.6f\n', Kp_p);
fprintf('Ki_p = %.6f\n', Ki_p);