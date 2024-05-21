function m_opt = runTrackLSQ_m(Estimatez)

    mdl = 'Main';
    open_system(mdl);
    in = Simulink.SimulationInput(mdl);
    in = in.setModelParameter('StopTime', '150.11');

    % Initial mass guess
    m0 = 0.032;

    % Optimizer options
    options = optimoptions(@lsqnonlin, 'Algorithm', 'levenberg-marquardt', ...
        'Display', 'off', 'StepTolerance', 0.001, 'OptimalityTolerance', 0.001);

    set_param(mdl, 'FastRestart', 'on');
    m_opt = lsqnonlin(@tracklsq, m0, [], [], options);
    set_param(mdl, 'FastRestart', 'off');

    function F = tracklsq(m)


        in = in.setVariable('m', m, 'Workspace',mdl);
        out = sim(in);
        
        F = out.zsim(8500:end, 1) - Estimatez(8500:end, 2); 

    end
end