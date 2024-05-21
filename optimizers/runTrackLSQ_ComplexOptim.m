
GroundTruth = [Estimatex(8500:end, 2), Estimatey(8500:end, 2), Estimatez(8500:end, 2)];

fv = runTrackLSQ_mI(GroundTruth);

function opt = runTrackLSQ_mI(GroundTruth)

    mdl = 'Main';
    open_system(mdl);
    in = Simulink.SimulationInput(mdl);
    in = in.setModelParameter('StopTime', '150.11');

    Ixx0 = 16.57*(10^(-6));
    Iyy0 = 16.57*(10^(-6));
    Izz0 = 29.26*(10^(-6));
    Ixy0 = 0.83*(10^(-6));
    Ixz0 = 0.72*(10^(-6));
    Iyz0 = 1.8*(10^(-6));
    
    % initGuess = [Ixx0, Iyy0, Izz0, Ixy0, Ixz0, Iyz0];
    initGuess = [Ixx0, Iyy0, Izz0, 0, 0, 0];

    disp(initGuess)

    % Optimizer options
    options = optimoptions(@lsqnonlin, 'Algorithm', 'levenberg-marquardt', ...
        'Display', 'off', 'StepTolerance', 0.001, 'OptimalityTolerance', 0.001);

    set_param(mdl, 'FastRestart', 'on');
    opt = lsqnonlin(@tracklsq, initGuess, [], [], options);
    set_param(mdl, 'FastRestart', 'off');
    
    function F = tracklsq(initGuess)
        % in = in.setVariable('m', initGuess(1), 'Workspace', mdl);

        I = [initGuess(1) initGuess(4) initGuess(5); 
             initGuess(4) initGuess(2) initGuess(6); 
             initGuess(5) initGuess(6) initGuess(3)];
        in = in.setVariable('I', I, 'Workspace', mdl);
        
        disp(I)

        out = sim(in);
        
        F = GroundTruth - [out.xsim(8500:end), out.ysim(8500:end), out.zsim(8500:end)];

    end
end