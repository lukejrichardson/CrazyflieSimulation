g = 9.81;

% Masses
m = 0.035; % Measured mass
% m = 0.0382; % Optimized mass

% Position and velocity PID period (100Hz)
Ts_PID_position = 0.01; % s
% Attitude and attitude rate PID period (500Hz)
Ts_PID_attitude = 0.002; % s

% Accurate body inertia matrix [kg.m^2]
I = 10^(-6)*[16.57   0.83   0.72; 0.83    16.66   1.8; 0.72    1.8     29.26];
% I = 10^(-6)*[227.43  0.83   0.72; 0.83    16.66   1.8; 0.72    1.8     29.26]; % Optimized on x displacement
% I = 10^(-6) * [78.78   0.83   0.72; 0.83    131.64   1.8; 0.72    1.8     29.26];

% Diagonal body inertia matrix [kg.m^2]
%I = 10^(-6)*[16.57   0   0; 0    16.66   0; 0    0     29.26];

% Alternate body inertia matrix [kg.m^2]
% I = 10^(-6)*[16.57*1.2      0.83        0.72/10;...
%             0.83        16.66*1.2       1.8*10;...
%             0.72/10     1.8*10      29.26*1.5];

I_inv = inv(I);

% Thrust coefficient
% k_t = (3.1582*10^(-10))/(((2*pi())/60)^2);     % N/(rad/s), CF system ID
k_t = 2.631011570958460e-08; % lsqnonlin optimized value on z
% k_t = 6.112275808845396e-08; % lsqnonlin optimized value on x

% Prop drag coefficient
k_q = (7.9379*10^(-12))/(((2*pi())/60)^2);    % N.m/(rad/s)

% Motor rotor/prop inertia
J_m = 0; % 1*10^(-6);    % kg.m^2

% Adjacent motor distance
d = 0.06761;    % m

% Loading crazyflie logged data into workspace for model verification

locationInputs = "Inputs-t,x,y,z,yaw.csv";
locationPose = "Pose-t,x,y,z,roll,pitch,yaw.csv";
locationMotors = "Motors-t,m1,m2,m3,m4.csv";


opts = detectImportOptions(locationInputs);
InputData = readmatrix(locationInputs,opts);
time = InputData(:,1);
input_x = InputData(:,2);
input_x = [time,input_x];
input_y = InputData(:,3);
input_y = [time,input_y];
input_z = InputData(:,4);
input_z = [time,input_z];
input_yaw = InputData(:,5);
input_yaw =[time,input_yaw];

opts = detectImportOptions(locationPose);
PoseData = readmatrix(locationPose,opts);
Estimatex= PoseData(:,2);
Estimatex=[time,Estimatex];
Estimatey= PoseData(:,3);
Estimatey=[time,Estimatey];
Estimatez= PoseData(:,4);
Estimatez=[time,Estimatez];
EstimateRoll= PoseData(:,5);
EstimateRoll=[time,EstimateRoll];
EstimatePitch= PoseData(:,6);
EstimatePitch=[time,EstimatePitch];
EstimateYaw= PoseData(:,7);
EstimateYaw=[time,EstimateYaw];

opts = detectImportOptions(locationMotors);
MotorData = readmatrix(locationMotors,opts);
m1= MotorData(:,2);
m1=[time,m1];
m2= MotorData(:,3);
m2=[time,m2];
m3= MotorData(:,4);
m3=[time,m3];
m4= MotorData(:,5);
m4=[time,m4];
