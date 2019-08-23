Transfer Learning with CNN on AMC

Motivation:
Some features of AWGN signals are also useful to Rayleigh signals, which helpful for:
1.reduce training cost(time/numbers of labeled data).
2.promote performance of classification problem about rayleigh signals.

Steps:
1. pretrain CNN us 
   (A)labeled data(AWGN).
   (B)unlabeled data(AWGN) - not performance well.
2. (A) fix weights of 1st convolutional layer, retrain(Rayleigh) 2nd convolutional layer and full-link layers.
   (B) fix weights of 1st and 2nd convolutional layer, retrain(Rayleigh) full-link layers.
   (C) finetune(Rayleigh) all layers.
3. test new model(Rayleigh).

Tips:
The features of convolutional layer can be viewed with gradient ascend method:
https://github.com/fchollet/deep-learning-with-python-notebooks/blob/master/5.4-visualizing-what-convnets-learn.ipynb
unlabeled data pretrain:
https://github.com/mikesj-public/convolutional_autoencoder