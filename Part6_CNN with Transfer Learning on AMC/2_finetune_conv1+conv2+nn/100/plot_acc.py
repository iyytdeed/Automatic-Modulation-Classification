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
acc = np.zeros(num_point)
cnt_sum = 0
for rows in data[0,:]:
    for ele in rows:
        cnt_sum = cnt_sum + ele
for i in range(num_point):
    snr[i] = EsNoLow + i*Gap
    cnt_acc = 0
    for j in range(nClass):
        cnt_acc = cnt_acc + data[i, j, j]
    acc[i] = cnt_acc/cnt_sum

plt.plot(snr, acc, 'o-', label = 'L = ' + str(L))

plt.grid(True)
#plt.legend(loc='lower right')
plt.xlim((EsNoLow, EsNoHigh))
plt.ylim((0,1))
plt.xlabel('SNR(dB)')
plt.ylabel('Pc')
#plt.title('CNN_AWGN')
plt.savefig('L' + str(L) + '.png', format='png')
res = np.vstack((snr, acc))
np.savetxt('acc.txt',res)
