% Using lsqnonlin to estimate the natural frequency and damping ration for
% the motor transfer function

function [w_n, zeta] = motorTFest(pitchRate)

mdl = 'MotorModelling';
open_system(mdl)
in = Simulink.SimulationInput(mdl);
in = in.setModelParameter('StopTime','0.25');
initGuess = [0.01 1];

options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt',...
   'Display','iter','StepTolerance',0.0000001,'OptimalityTolerance',0.0000001);

set_param(mdl,'FastRestart','on');
w_nZeta = lsqnonlin(@tracklsq,initGuess,[],[],options);
set_param(mdl,'FastRestart','off');

w_n = w_nZeta(1); zeta = w_nZeta(2);

function F = tracklsq(w_nZeta)
    in = in.setVariable('w_n',w_nZeta(1),'Workspace',mdl);
    in = in.setVariable('zeta',w_nZeta(2),'Workspace',mdl);

    out = sim(in);
    F = out.get("simPitchRate") - pitchRate(1:26,2);
end
end