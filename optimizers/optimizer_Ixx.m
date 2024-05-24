Ixx_opt = optimize(Estimatey);
disp(Ixx_opt)

function Ixx_opt = optimize(Estimate)
    
    mdl = 'Main';
    open_system(mdl)
    in = Simulink.SimulationInput(mdl);
    in = in.setModelParameter('StopTime', '150.11');

    Ixx_0 = 16.57;

    options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt',...
    'Display','iter-detailed','StepTolerance',0.001,'OptimalityTolerance',0.001);

    % Optimize the mass
    set_param(mdl, 'FastRestart', 'on');
    Ixx_opt = lsqnonlin(@tracklsq, Ixx_0, [], [], options);
    set_param(mdl, 'FastRestart', 'off');
    
    function F = tracklsq(v_iter)
        %disp(m)

        I = 10^(-6)*[v_iter   0.83   0.72; 0.83    16.66   1.8; 0.72    1.8     29.26];

        in = in.setVariable('I', I, 'Workspace', mdl);

        % Simulate
        out = sim(in);
        F = out.ysim(1000:end) - Estimate(1000:end, 2);
    end
end