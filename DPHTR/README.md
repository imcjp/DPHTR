The folder is the toolkit for differential privacy hierarchy tree release (DPHTR).

The main code structures are as follows:

1. **coreOfTree**: We implemented the major functions related to hierarchical trees, including building hierarchical trees, applying Generation Matrix to process hierarchical trees, etc.
2. **dpRelease**: We have implemented multiple DPHTR algorithms for consistency release, as follows.
Processless: No processing after adding noise.
Boosting[1]: The classic optimally consistent release only for complete tree.
PrivTrie[2]: The optimally consistent release for any hierarchical tree in [2]
GMC[3]: The optimally consistent release based on GM.
ForcePos: Set the negative noise node to 0 for non-negtive release.
IPC: The general quadratic programming algorithm for optimally non-negtive consistent release by Interior Point Convex Method.
GMNC: Our optimally non-negtive consistent release based on GM.
3. **noiseMeches**: We implement Laplace mechanism and Gaussian mechanism to provide privacy protection, where the Gaussian mechanism is implemented with the theory of f-DP[4].
4. **tools**: Some tools for our work.

[Reference]

[1] V. M. G. S. D. Hay, Michael; Rastogi, "Boosting the accuracy of differentially private histograms through consistency," Proceedings of the VLDB Endowment vol. 3 iss. 1-2, vol. 3, sep 2010.

[2] N. Wang, X. Xiao, Y. Yang, T. Hoang, H. Shin, J. Shin, and G. Yu, "Privtrie: Effective frequent term discovery under local differential privacy." IEEE, 04 2018

[3] J. Cai, X. Liu, J. Li, and S. Zhang, "Generation matrix: An embedable matrix representation for hierarchical trees," arXiv preprint arXiv:2201.11297, 2022

[4] J. Dong, A. Roth, and W. J. Su, "Gaussian differential privacy," Journal of the Royal Statistical Society Series B, vol. 84, no. 1, pp. 3–37, 2022.
