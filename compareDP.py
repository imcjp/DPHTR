

from tensorflow_privacy.privacy.analysis.gdp_accountant import compute_eps_poisson
from tensorflow_privacy.privacy.analysis.gdp_accountant import compute_eps_uniform
from tensorflow_privacy.privacy.analysis.gdp_accountant import compute_mu_poisson


from opacus import PrivacyEngine
from opacus.accountants.analysis import rdp as privacy_analysis

DEFAULT_ALPHAS = [1 + x / 10.0 for x in range(1, 100)] + list(range(12, 64))
def get_privacy_spent(
        sample_rate, num_steps, delta: float,sigma=1.0, alphas = None
):

    if alphas is None:
        alphas = DEFAULT_ALPHAS
    noise_multiplier=sigma;
    rdp = privacy_analysis.compute_rdp(
                q=sample_rate,
                noise_multiplier=noise_multiplier,
                steps=num_steps,
                orders=alphas,
            )
    eps, best_alpha = privacy_analysis.get_privacy_spent(
        orders=alphas, rdp=rdp, delta=delta
    )
    return float(eps), float(best_alpha)


num_examples=3000
sampling_batch=3000
noise_multiplier=1
epochs=range(1,100)
resEps=[];
resEps1=[];
resEps2=[];
delta=1e-5;
for epoch in epochs:
    print(epoch)
    resEps.append(compute_eps_poisson(epoch, noise_multiplier, num_examples, sampling_batch, delta))
    resEps1.append(compute_eps_uniform(epoch, noise_multiplier, num_examples, sampling_batch, delta))
    eps,best_alpha=get_privacy_spent(sampling_batch/num_examples,epoch,delta,sigma=noise_multiplier)
    resEps2.append(eps)

import matplotlib.pyplot as plt

plt.plot(epochs, resEps, 'r-')
plt.plot(epochs, resEps1, 'k-')
plt.plot(epochs, resEps2, 'b-')
plt.show()