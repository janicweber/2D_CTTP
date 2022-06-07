function bixelweights = optimiser(dose, voxelweight)

    disp("---optimizing fluence map")
    [~,n] = size(dose);
    d_max = voxelweight.maxdose;
    w_o = voxelweight.overdosepenalty;
    d_min = voxelweight.mindose;
    w_u = voxelweight.underdosepenalty;

    x0 = 10*ones(n,1);
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    lb = zeros(n,1);
    ub = inf*ones(n,1);
    nonlcon = [];

    function [obj, grad] = calculate_quadratic_objective_and_gradient(x)
        d = dose*x;
        obj = sum(w_o .* max(0, d - d_max).^2 + w_u .* max(0, d_min - d).^2);
        grad = zeros(n, 1);

        for i = 1:1:n
            s = sum((2 .* w_o .* max(0,d - d_max) - ...
            2 .* w_u .* max(0,d_min - d)) .* dose(:,i));
            grad(i) = s;
        end
        
        return
    end

    % 'Algorithm' options 'sqp', 'interior-point'
    % 'Display' options 'iter'
    options = optimoptions('fmincon','SpecifyObjectiveGradient',true, ...
    'Display', 'off', 'Algorithm', 'sqp');
    fun = @calculate_quadratic_objective_and_gradient;
    x = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);
    bixelweights = x;

    disp("---finished")

    return
end