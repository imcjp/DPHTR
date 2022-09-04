function sigma = classicalGaussSigma(eplison,delta,sensitivity)
%% Classical Gaussian Mechanism
    if eplison>1
        sigma=nan;
    else
        sigma=sensitivity*sqrt(2*log(1.25/delta))/eplison;
    end
end

