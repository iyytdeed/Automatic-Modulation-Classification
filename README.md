# Automatic-Modulation-Classification

Source Code for Master Thesis

Research on Deep Learning Based Modulation Recognition Technologies

Author: ZhiKun Lei

Lab: Center for Intelligent Network and Communication

School: National Key Laboratory of Science and Technology on Communication

University: University of Electronic Science and Technology of China

Version: Matlab2017a Python2.7.15 Keras2.2 Tensorflow(i forget :p)

&nbsp;

Some Notes:

Hope these code will be helpful for someone like me who struggled for a master degree.

If these codes are helpful for you. Plz click star to support me :)

Not Guaranteed To Be Correct.

Thank you for reading.

2019.8.23 Update Stop.

---

### Part 0 - CNN Based AMC
- AWGN channel signals
- Rayleigh channel signals

---

### Part 1 - Likelihood Based AMC
- simulation of paper - F. Hameed, O. A. Dobre, D. Popescu. On the likelihood-based approach to modulation classification[J]. IEEE Transactions on Wireless Communications, 2009, 8(12): 5884-5892 - fig.6 ALRT-UB for {BPSK, QPSK}
- AWGN Channel
- Rayleigh Channel
- Freqency Offset
- Phase Jitter

---

### Part 2 - Cumulant Based AMC
- simulation of paper - A. Swami, B. M Sadler. Hierarchical digital modulation classification using cumulants[J].IEEE Transactions on communications, 2000, 48(3): 416-429
- extract cumulant features
- cumulant features + thershold classifer
- cumulant features + neural network classifer

---

### Part 3 - Instantaneous Signal Feature Based AMC
- extract instantaneous features - refer paper: E. E. Azzouz, A. K. Nandi. Automatic identification of digital modulation types[J]. Signal Processing, 1995, 47(1):55-69
- instantaneous features + decision tree classifer
- instantaneous features + neural network classifer

---

### Part 4 - CNN Based AMC
- Train CNN Model
- Test CNN Model
- Some Result

Paper Recommend:
  - J. O’Shea, T. Roy, T. C. Clancy. Over-the-air deep learning based radio signal classification[J]. IEEE Journal of Selected Topics in Signal Processing, 2018, 12(1): 168-179
  - F. Meng, P. Chen, L. Wu, et al. Automatic modulation classification: A deep learning enabled approach[J]. IEEE Transactions on Vehicular Technology, 2018, 67(11): 10760-10772

---

### Part 5 - RNN Based AMC
- Train RNN(SimpleRNN GRU LSTM) Model
- Test RNN Model 
- Some Result
Paper Recommend:
  - S. Rajendran, W. Meert, D. Giustiniano, et al. Deep Learning Models for Wireless Signal Classification with Distributed Low-Cost Spectrum Sensors[J]. IEEE Transactions on Cognitive Communications and Networking, 2018, 11(99):1-13
  - S. Hu, Y. Pei, P. P. Liang, et al. Robust Modulation Classification under Uncertain Noise Condition Using Recurrent Neural Network[C]. IEEE Global Communications Conference, 2018, 1-7

---

### Part 6 - CNN with Transfer Learning on AMC
- Pretrain CNN(labeled data - ordinary training method/ unlabeled data - autoencoder)
- Retrain or Finetune CNN
Paper Recommend:
  - J. Yosinski, J. Clune, A. Nguyen, et al. Understanding neural networks through deep visualization[J]. arXiv preprint arXiv:1506.06579, 2015

---

