g = 9.81;

m = 0.030;


% Accurate body inertia matrix [kg.m^2]
% I = 10^(-6)*[16.57   0.83   0.72; 0.83    16.66   1.8; 0.72    1.8     29.26];

% Diagonal body inertia matrix [kg.m^2]
I = 10^(-6)*[16.57   0   0; 0    16.66   0; 0    0     29.26];

% Alternate body inertia matrix [kg.m^2]
% I = 10^(-6)*[16.57*1.2      0.83        0.72/10;...
%             0.83        16.66*1.2       1.8*10;...
%             0.72/10     1.8*10      29.26*1.5];

I_inv = inv(I);

% Thrust coefficient
k_t = (3.1582*10^(-10))/(((2*pi())/60)^2);     % N/(rad/s)

% Prop drag coefficient
k_q = (7.9379*10^(-12))/(((2*pi())/60)^2);    % N.m/(rad/s)

% Motor rotor/prop inertia
J_m = 0; % 1*10^(-6);    % kg.m^2

% Adjacent motor distance
d = 0.06761;    % m
