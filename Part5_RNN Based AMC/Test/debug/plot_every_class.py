import numpy as np
import matplotlib.pyplot as plt

L = 100
load_path = 'pred_confusion_mat_L' + str(L) + '.npy'
data = np.load(load_path)

EsNoLow = -10
EsNoHigh = 20
Gap = 2
nClass = data.shape[1]

num_point = (int)((EsNoHigh-EsNoLow)/Gap) + 1
snr = np.zeros(num_point)
acc_bpsk = np.zeros(num_point)
acc_4qam = np.zeros(num_point)
acc_8psk = np.zeros(num_point)
acc_16qam = np.zeros(num_point)

cnt_sum = 0
for rows in data[0,:]:
    for ele in rows:
        cnt_sum = cnt_sum + ele
cnt_sum_single_class = cnt_sum/nClass

for i in range(num_point):
    snr[i] = EsNoLow + i*Gap
    acc_bpsk[i] = data[i, 0, 0]/cnt_sum_single_class
    acc_4qam[i] = data[i, 1, 1]/cnt_sum_single_class
    acc_8psk[i] = data[i, 2, 2]/cnt_sum_single_class
    acc_16qam[i] = data[i, 3, 3]/cnt_sum_single_class

LineWidth = 1.0
for i in range(nClass):
    if i == 0:
        plt.plot(snr, acc_bpsk, '*-', linewidth = LineWidth, label = 'BPSK')
    elif i == 1:
        plt.plot(snr, acc_4qam, 'o-', linewidth = LineWidth, label = '4QAM')
    elif i == 2:
        plt.plot(snr, acc_8psk, '^-', linewidth = LineWidth, label = '8PSK')
    elif i == 3:
        plt.plot(snr, acc_16qam, '<-', linewidth = LineWidth, label = '16QAM')

plt.grid(True)
plt.legend(loc='lower right')
plt.xlim((EsNoLow, EsNoHigh))
plt.ylim((0,1))
plt.xlabel('SNR(dB)')
plt.ylabel('Pc')
#plt.title('CNN_AWGN_EveryClass(L = 100)')
plt.savefig('every_class_L' + str(L) + '.png', format='png')

