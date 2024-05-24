IxxIyy_opt = optimize([Estimatey(:,2), Estimatex(:,2)]);
disp(IxxIyy_opt)

function Ixx_opt = optimize(Estimate)
    
    mdl = 'Main';
    open_system(mdl)
    in = Simulink.SimulationInput(mdl);
    in = in.setModelParameter('StopTime', '150.11');

    I_0 = [16.57, 16.66];

    options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt',...
    'Display','iter-detailed','StepTolerance',0.001,'OptimalityTolerance',0.001);

    % Optimize the mass
    set_param(mdl, 'FastRestart', 'on');
    Ixx_opt = lsqnonlin(@tracklsq, I_0, [], [], options);
    set_param(mdl, 'FastRestart', 'off');
    
    function F = tracklsq(v_iter)
        %disp(m)

        I = 10^(-6)*[v_iter(1)   0.83   0.72; 0.83    v_iter(2)   1.8; 0.72    1.8     29.26];

        in = in.setVariable('I', I, 'Workspace', mdl);

        % Simulate
        out = sim(in);

        Estimatey = Estimate(:,1);
        Estimatex = Estimate(:,2);

        F = out.ysim(1000:end) - Estimatey(1000:end) + out.xsim(1000:end) - Estimatex(1000:end);
    end
end