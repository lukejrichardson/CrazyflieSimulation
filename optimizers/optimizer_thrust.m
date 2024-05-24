thrust_opt = optimize(Estimatex);
disp(thrust_opt)

function thrust_opt = optimize(Estimate)
    
    mdl = 'Main';
    open_system(mdl)
    in = Simulink.SimulationInput(mdl);
    in = in.setModelParameter('StopTime', '150.11');
    k_t0 = (3.1582*10^(-10))/(((2*pi())/60)^2); 

    options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt',...
    'Display','iter-detailed','StepTolerance',0.001,'OptimalityTolerance',0.001);

    % Optimize the mass
    set_param(mdl, 'FastRestart', 'on');
    thrust_opt = lsqnonlin(@tracklsq, k_t0, [], [], options);
    set_param(mdl, 'FastRestart', 'off');
    
    function F = tracklsq(k_t_iter)
        %disp(m)
        in = in.setVariable('k_t', k_t_iter, 'Workspace', mdl);

        % Simulate
        out = sim(in);
        F = out.xsim(1000:end) - Estimate(1000:end, 2);
    end
end