mass_opt = optimize(Estimatez);
disp(mass_opt)

function mass_opt = optimize(Estimatez)
    
    mdl = 'Main';
    open_system(mdl)
    in = Simulink.SimulationInput(mdl);
    in = in.setModelParameter('StopTime', '150.11');
    m0 = 32/1000;

    options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt',...
    'Display','iter-detailed','StepTolerance',0.001,'OptimalityTolerance',0.001);

    % Optimize the mass
    set_param(mdl, 'FastRestart', 'on');
    mass_opt = lsqnonlin(@tracklsq, m0, [], [], options);
    set_param(mdl, 'FastRestart', 'off');
    
    function F = tracklsq(m)
        %disp(m)
        in = in.setVariable('m', m, 'Workspace', mdl);

        % Simulate
        out = sim(in);
        F = out.zsim(1000:end) - Estimatez(1000:end, 2);
    end
end