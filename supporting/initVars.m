g = 9.81;

m = 0.032;

% Position and velocity PID period (100Hz)
Ts_PID_position = 0.01; % s
% Attitude and attitude rate PID period (500Hz)
Ts_PID_attitude = 0.002; % s

% Accurate body inertia matrix [kg.m^2]
I = 10^(-6)*[16.57171   0.830806   0.718277;...
            0.830806    16.655602    1.800197;...
            0.718277    1.800197     29.261652];
          
% Diagonal body inertia matrix [kg.m^2]
% I = 10^(-6)*[16.57171   0   0; 0    16.655602   0; 0    0     29.261652];

% Thrust coefficient
k_t = (3.1582*10^(-10))/(((2*pi())/60)^2);     % N/(rad/s)

% Prop drag coefficient
k_q = (7.9379*10^(-12))/(((2*pi())/60)^2);    % N.m/(rad/s)

% Motor rotor/prop inertia
J_m = 0;     % kg.m^2

% Adjacent motor distance
d = 0.065;    % m

% gyro low pass filter parameters
BW = 116; % Filter bandwidth (Hz)
fs = 1000; % Output data rate (Hz)
Ts = 1/fs; % s
Tc = 1/(2*pi*BW); % s
a = exp(-Ts/Tc);

% Loading crazyflie logged data into workspace for model verification

locationInputs = "Inputs-t,x,y,z,yaw.csv";
locationPose = "Pose-t,x,y,z,roll,pitch,yaw.csv";
%locationAttRateController = "AttRateController-t,gyroRollRate,gyroPitchRate,inputRollRate,inputPitchRate,outputRollRate,outputPitchRate.csv";
% locationPoseRates = "PoseRates-t,vx,vy,vz,rateRoll,ratePitch,rateYaw.csv";
locationMotors = "Motors-t,m1,m2,m3,m4.csv";
% locationPosIntegs = "PosIntegrators-t,Xi,Yi,Zi,VXi,VYi,VZi.csv";
% locationAttIntegs = "AttIntegrators-t,rollI,pitchI,yawI,rollRateI,pitchRateI,yawRateI.csv";
% locationMotorModelling = "MotorModelling-t,inputx,m1,m2,m3,m4,ratePitch.csv";
% locationPoseCtr = "posCtr-t,p,i,d.csv";
% locationVelCtr = "velCtr-t,p,i,d.csv";
% locationPosCmd = "cmdPos-t,x,y,z.csv";
% locationVelCmd = "cmdVel-t,vx,vy,vz.csv";
% locationPosXCtrl = "posXCtrl-t,p,i,d.csv";
% locationPosXState = "PosX_cmd,state,p.csv";
% locationPosXOut = "PosXOutputs-t,targetX,Xp,TargetDX.csv";
% locationVelCtrl = "VelCtrl-dx,VXp,VXi.csv";
% locationPitchIn = "PitchInputs-t,dxP,dxI,state_pitch.csv";
% locationPitchPID = "PitchPID-t,p,i.csv";
% locationDZ = "dzCtrl-t,p,i.csv";
% locationThrust = "Thrust-t,actuator,cmd,stabiliser.csv";


% opts = detectImportOptions(locationDZ);
% DZData = readmatrix(locationDZ,opts);
% time = DZData(:,1);
% dz_p = DZData(:,2);
% dz_p = [time,dz_p];
% dz_i = DZData(:,3);
% dz_i = [time,dz_i];
% 
% opts = detectImportOptions(locationThrust);
% ThrustData = readmatrix(locationThrust,opts);
% time = ThrustData(:,1);
% actuatorThrust = ThrustData(:,2);
% actuatorThrust = [time,actuatorThrust];
% cmdThrust = ThrustData(:,3);
% cmdThrust = [time,cmdThrust];
% stabThrust = ThrustData(:,4);
% stabThrust = [time,stabThrust];

% opts = detectImportOptions(locationPitchIn);
% PitchInData = readmatrix(locationPitchIn,opts);
% time = PitchInData(:,1);
% dx_p = PitchInData(:,2);
% dx_p = [time,dx_p];
% dx_i = PitchInData(:,3);
% dx_i = [time,dx_i];
% state_pitch = PitchInData(:,4);
% state_pitch = [time,state_pitch];

% opts = detectImportOptions(locationPitchPID);
% PitchPIDData = readmatrix(locationPitchPID,opts);
% time = PitchPIDData(:,1);
% pitch_p = PitchPIDData(:,2);
% pitch_p = [time,pitch_p];
% pitch_i = PitchPIDData(:,3);
% pitch_i = [time,pitch_i];


% opts = detectImportOptions(locationPosXOut);
% PosCtrlData = readmatrix(locationPosXOut,opts);
% time = PosCtrlData(:,1);
% target_x = PosCtrlData(:,2);
% target_x = [time,target_x];
% x_p = PosCtrlData(:,3);
% x_p = [time,x_p];
% target_dx = PosCtrlData(:,4);
% target_dx = [time,target_dx];
% 
% opts = detectImportOptions(locationVelCtrl);
% VelCtrlData = readmatrix(locationVelCtrl,opts);
% time = VelCtrlData(:,1);
% state_dx = VelCtrlData(:,2);
% state_dx = [time,state_dx];
% dx_p = VelCtrlData(:,3);
% dx_p = [time,dx_p];
% dx_i = VelCtrlData(:,4);
% dx_i = [time,dx_i];



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

% opts = detectImportOptions(locationAttRateController);
% AttRateControllerData = readmatrix(locationAttRateController);
% gyroRollRate = [time, AttRateControllerData(:,2)];
% gyroPitchRate = [time, AttRateControllerData(:,3)];
% inputRollRate = [time, AttRateControllerData(:,4)];
% inputPitchRate = [time, AttRateControllerData(:,5)];
% outputRollRate = [time, AttRateControllerData(:,6)];
% outputPitchRate = [time, AttRateControllerData(:,7)];

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
% lighthouseStatus = MotorData(:,6);
% lighthouseStatus = [time,lighthouseStatus];


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

% opts = detectImportOptions(locationPoseCtr);
% PoseCtrData = readmatrix(locationPoseCtr,opts);
% time = PoseCtrData(:,1);
% poseCtr_p = PoseCtrData(:,2);
% poseCtr_p = [time,poseCtr_p];
% poseCtr_i = PoseCtrData(:,3);
% poseCtr_i = [time,poseCtr_i];
% poseCtr_d = PoseCtrData(:,4);
% poseCtr_d = [time,poseCtr_d];

% opts = detectImportOptions(locationVelCtr);
% VelCtrData = readmatrix(locationVelCtr,opts);
% time = VelCtrData(:,1);
% velCtr_p = VelCtrData(:,2);
% velCtr_p = [time,velCtr_p];
% velCtr_i = VelCtrData(:,3);
% velCtr_i = [time,velCtr_i];
% velCtr_d = VelCtrData(:,4);
% velCtr_d = [time,velCtr_d];

% opts = detectImportOptions(locationVelCmd);
% VelCmdData = readmatrix(locationVelCmd,opts);
% time = VelCmdData(:,1);
% velCmd_vx = VelCmdData(:,2);
% velCmd_vx = [time,velCmd_vx];
% velCmd_vy = VelCmdData(:,3);
% velCmd_vy = [time,velCmd_vy];
% velCmd_vz = VelCmdData(:,4);
% velCmd_vz = [time,velCmd_vz];

% opts = detectImportOptions(locationPosCmd);
% PosCmdData = readmatrix(locationPosCmd,opts);
% time = PosCmdData(:,1);
% posCmd_x = PosCmdData(:,2);
% posCmd_x = [time,posCmd_x];
% posCmd_y = PosCmdData(:,3);
% posCmd_y = [time,posCmd_y];
% posCmd_z = PosCmdData(:,4);
% posCmd_z = [time,posCmd_z];

% opts = detectImportOptions(locationPosXCtrl);
% PosXData = readmatrix(locationPosXCtrl,opts);
% time = PosXData(:,1);
% posX_p = PosXData(:,2);
% posX_p = [time,posX_p];
% posX_i = PosXData(:,3);
% posX_i = [time,posX_i];
% posX_d = PosXData(:,4);
% posX_d = [time,posX_d];

% opts = detectImportOptions(locationPosXState);
% PosXStateData = readmatrix(locationPosXState,opts);
% time = PosXStateData(:,1);
% posCmd_x = PosXStateData(:,2);
% posCmd_x = [time,posCmd_x];
% posState_x = PosXStateData(:,3);
% posState_x = [time,posState_x];
% pos_Xp = PosXStateData(:,4);
% pos_Xp = [time,pos_Xp];