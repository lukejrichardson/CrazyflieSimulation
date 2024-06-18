g = 9.81;

m = 0.032;

% Position and velocity PID period (100Hz)
Ts_PID_position = 0.01; % s
% Attitude and attitude rate PID period (500Hz)
Ts_PID_attitude = 0.002; % s

% Accurate body inertia matrix [kg.m^2]
I = 10^(-6)*[16.57   0.83   0.72; 0.83    16.66    1.8; 0.72    1.8     29.26];

% Diagonal body inertia matrix [kg.m^2]
% I = 10^(-6)*[16.57   0   0; 0    16.66   0; 0    0     29.26];

% Alternate body inertia matrix [kg.m^2]
% I = 10^(-6)*[16.57*1.2      0.83        0.72/10;...
%             0.83        16.66*1.2       1.8*10;...
%             0.72/10     1.8*10      29.26*1.5];

% Thrust coefficient
k_t = (3.1582*10^(-10))/(((2*pi())/60)^2);     % N/(rad/s)

% Prop drag coefficient
k_q = (7.9379*10^(-12))/(((2*pi())/60)^2);    % N.m/(rad/s)

% Motor rotor/prop inertia
J_m = 0;     % kg.m^2

% Adjacent motor distance
d = 0.065;    % m

% Loading crazyflie logged data into workspace for model verification

locationInputs = "Inputs-t,x,y,z,yaw.csv";
locationPose = "Pose-t,x,y,z,roll,pitch,yaw.csv";
% locationPoseRates = "PoseRates-t,vx,vy,vz,rateRoll,ratePitch,rateYaw.csv";
locationMotors = "Motors-t,m1,m2,m3,m4.csv";
% locationPosIntegs = "PosIntegrators-t,Xi,Yi,Zi,VXi,VYi,VZi.csv";
% locationAttIntegs = "AttIntegrators-t,rollI,pitchI,yawI,rollRateI,pitchRateI,yawRateI.csv";
% locationMotorModelling = "MotorModelling-t,inputx,m1,m2,m3,m4,ratePitch.csv";

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


% opts = detectImportOptions(locationPoseRates);
% PoseRateData = readmatrix(locationPoseRates,opts);
% Estimatevx= PoseRateData(:,2);
% Estimatevx=[time,Estimatevx];
% Estimatevy= PoseRateData(:,3);
% Estimatevy=[time,Estimatevy];
% Estimatevz= PoseRateData(:,4);
% Estimatevz=[time,Estimatevz];
% EstimateRollRate= PoseRateData(:,5);
% EstimateRollRate=[time,EstimateRollRate];
% EstimatePitchRate= PoseRateData(:,6);
% EstimatePitchRate=[time,EstimatePitchRate];
% EstimateYawRate= PoseRateData(:,7);
% EstimateYawRate=[time,EstimateYawRate];


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


% opts = detectImportOptions(locationPosIntegs);
% PosIData = readmatrix(locationPosIntegs,opts);
% time = PosIData(:,1);
% Xinteg = PosIData(:,2);
% Xinteg = [time,Xinteg];
% Yinteg = PosIData(:,3);
% Yinteg = [time,Yinteg];
% Zinteg = PosIData(:,4);
% Zinteg = [time,Zinteg];
% VXinteg = PosIData(:,5);
% VXinteg =[time,VXinteg];
% VYinteg= PosIData(:,6);
% VYinteg=[time,VYinteg];
% VZinteg= PosIData(:,7);
% VZinteg=[time,VZinteg];
% 
% 
% opts = detectImportOptions(locationAttIntegs);
% AttIData = readmatrix(locationAttIntegs,opts);
% time = AttIData(:,1);
% RollInteg = AttIData(:,2);
% RollInteg = [time,RollInteg];
% PitchInteg = AttIData(:,3);
% PitchInteg = [time,PitchInteg];
% YawInteg = AttIData(:,4);
% YawInteg = [time,YawInteg];
% RollRateInteg = AttIData(:,5);
% RollRateInteg =[time,RollRateInteg];
% PitchRateInteg= AttIData(:,6);
% PitchRateInteg=[time,PitchRateInteg];
% YawRateInteg= AttIData(:,7);
% YawRateInteg=[time,YawRateInteg];

% opts = detectImportOptions(locationMotorModelling);
% MotorModellingData = readmatrix(locationMotorModelling,opts);
% time = MotorModellingData(:,1);
% input_x = MotorModellingData(:,2);
% input_x = [time, input_x];
% m1= MotorModellingData(:,3);
% m1=[time,m1];
% m2= MotorModellingData(:,4);
% m2=[time,m2];
% m3= MotorModellingData(:,5);
% m3=[time,m3];
% m4= MotorModellingData(:,6);
% m4=[time,m4];
% pitchRate= MotorModellingData(:,7);
% pitchRate=[time,pitchRate];