stip_fisher
===========

Action recognition with STIP features and my own Fisher vector implementation

This project contains the full pipeline(1-vs-rest) of action recognition on UCF 101 with STIP features(downloaded from here: http://crcv.ucf.edu/ICCV13-Action-Workshop/download.html). Fisher vector encoding is used in this project, and the default Fisher vector used in this project is written by myself with Matlab(so it is very slow). Gaussian Mixture Model(GMM) codebook is trained by the VGG implementation(so VLFeat is required, http://www.vlfeat.org/). And LIBSVM is adopted for classification.

To automatically unzip the original STIP features, after uncompressing the downloaded two STIP features, merge them in the same folder(totally 101 zipped files, correponding to the 101 actions), and run script 
	"unzip_stip_files -i <STIP_DIR>"

To extract STIP features for each video clip(by default all features of the videos in the same class are mixed in the same file), you also need to run script 
	"mk_stip_data -i <in_dir> -o <out_dir>"

Using this pipeline, the mean accuracy of UCF 101 action recognition should be no lower than 77.95%.

For theoretical introduction about this project, please refer to [Action Recognition with Fisher Vectors](http://www.bo-yang.net/2014/04/30/fisher-vector-in-action-recognition) and [DTF Notes](http://www.bo-yang.net/2014/01/10/dense-trajectory-notes) on [my blog](http://bo-yang.github.io).
