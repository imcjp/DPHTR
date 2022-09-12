# Code for Differentially Private Non-Negative Consistent Release for Large-Scale Hierarchical Trees

The project is the code for the paper **"Differentially Private Non-Negative Consistent Release for Large-Scale Hierarchical Trees"**. The authors are Jianping Cai, Ximeng Liu*, Jiayin Li and Kim-Kwang Raymond Choo.

In this project, we design an efficient Generation Matrix-based optimally non-negative consistent release algorithm (GMNC), which can easily handle large-scale hierarchical trees with more than $100$ million nodes. The algorithm employs our proposed Generation Matrix[1] to find Unconstrained Set Expansion Theorem, thus achieving a great improvement in performance and dependability.

The software environment of the source code requires **MATLAB 2017**.

**Note:** Since we adopt the real datasets of hierarchical trees with node scale up to 10 million, running the complete data requires sufficient memory, e.g. 32G. Otherwise, you can choose a smaller dataset to execute in our script.

#### Instructions:

1. We developed a toolkit for differential privacy hierarchy tree release (DPHTR). The folder "DPHTR" is the toolkit and you can open it for more detail. Users can use it by adding the folder and its subfolders to the path of Matlab or using the Matlab code "addpath(genpath('DPHTR'));" to add the path.
2. We provide a script "main.m" to help users quickly implement DPHTR using our code. In this script, we provide three datasets ('Census2010', 'Trip2013', 'SynData') and seven algorithm settings ('Processless', 'Boosting', 'PrivTrie', 'GMC', 'ForcePos', 'IPC', 'GMNC') as choices. Users can set parameters according to the script's comments such as dataset, algorithm and data size, privacy budget, etc.
3. In folder "GSMeches", we implemented and compared various Gaussian Mechanisms, which are the classical Gaussian Mechanisms[2], RDP-based Gaussian Mechanisms[3], analytical Gaussian Mechanisms[4], enhanced RDP-based Gaussian Mechanisms[5], and Gaussian Mechanisms based on f-DP[6].
4. Notably, since this work has not been formally published, we temporarily hide some parts of the core codes, including our proposed GMNC. The hidden code is compiled into p-code to provide experimentation and verification.

If you have any questions or suggestions for improvement, please contact email jpingcai@163.com. Thank you!

[Reference]

[1] J. Cai, X. Liu, J. Li, and S. Zhang, "Generation matrix: An embedable matrix representation for hierarchical trees," arXiv preprint arXiv:2201.11297, 2022.

[2] C. Dwork and A. Roth, "The algorithmic foundations of differential privacy," vol. 9, pp. 211–407, 01 2014.

[3] I. Mironov, "Renyi differential privacy," 02 2017.

[4] B. Balle and Y.-X. Wang, "Improving the gaussian mechanism for differential privacy: Analytical calibration and optimal denoising," 05 2018.

[5] S. Asoodeh, J. Liao, F. P. Calmon, O. Kosut, and L. Sankar, "A better bound gives a hundred rounds: Enhanced privacy guarantees via f-divergences," in 2020 IEEE International Symposium on Information Theory (ISIT). IEEE, 2020, pp. 920–925.

[6]  J. Dong, A. Roth, and W. J. Su, "Gaussian differential privacy," Journal of the Royal Statistical Society Series B, vol. 84, no. 1, pp. 3–37, 2022.
