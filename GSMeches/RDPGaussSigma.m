function sigma = RDPGaussSigma(eplison,delta,sensitivity)
	sigma=sensitivity/(sqrt(2)*(sqrt(log(1/delta)+eplison)-sqrt(log(1/delta))));
end

