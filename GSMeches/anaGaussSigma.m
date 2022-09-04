function sigma = anaGaussSigma(epsilon, delta,sensitivity)
%% Implementing the Analytical Gaussian Mechanism, the reference paper is as follows:
% [1]  Ba Lle B ,  Wang Y X . Improving the Gaussian Mechanism for Differential Privacy: Analytical Calibration and Optimal Denoising[J].  2018.
tol=1.e-8;
delta_thr = caseA(epsilon, 0.0);

if (delta == delta_thr)
    alpha = 1.0;
    sigma = alpha*sensitivity / sqrt(2.0 * epsilon);
else
    if (delta > delta_thr)
        predicate_stop_DT = @(s) (caseA(epsilon, s) >= delta);
        function_s_to_delta = @(s) (caseA(epsilon, s));
        predicate_left_BS = @(s)(function_s_to_delta(s) > delta);
        function_s_to_alpha = @(s)(sqrt(1.0 + s/2.0) - sqrt(s/2.0));
    else
        predicate_stop_DT = @(s) (caseB(epsilon, s) <= delta);
        function_s_to_delta = @(s) (caseB(epsilon, s));
        predicate_left_BS = @(s) (function_s_to_delta(s) < delta);
        function_s_to_alpha = @(s) (sqrt(1.0 + s/2.0) + sqrt(s/2.0));
    end
    predicate_stop_BS = @(s) (abs(function_s_to_delta(s) - delta) <= tol);
    [s_inf, s_sup]=doubling_trick(predicate_stop_DT, 0.0, 1.0);
    s_final = binary_search(predicate_stop_BS, predicate_left_BS, s_inf, s_sup);
    alpha = function_s_to_alpha(s_final);
    sigma = alpha*sensitivity/sqrt(2.0*epsilon);
end
end

function res = caseA(epsilon,s)
res = Phi(sqrt(epsilon*s)) - exp(epsilon)*Phi(-sqrt(epsilon*(s+2.0)));
end

function res = caseB(epsilon,s)
res = Phi(-sqrt(epsilon*s)) - exp(epsilon)*Phi(-sqrt(epsilon*(s+2.0)));
end

function [s_inf, s_sup]=doubling_trick(predicate_stop, s_inf, s_sup)
    while ~predicate_stop(s_sup)
        s_inf = s_sup;
        s_sup = 2.0*s_inf;
    end
end
function s_mid=binary_search(predicate_stop, predicate_left, s_inf, s_sup)
    s_mid = s_inf + (s_sup-s_inf)/2.0;
    while ~predicate_stop(s_mid)
        if (predicate_left(s_mid))
            s_sup = s_mid;
        else
            s_inf = s_mid;
        end
        s_mid = s_inf + (s_sup-s_inf)/2.0;
    end
end

