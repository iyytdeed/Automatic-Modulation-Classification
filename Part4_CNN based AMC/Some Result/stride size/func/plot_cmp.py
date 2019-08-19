import numpy as np
import matplotlib.pyplot as plt

cnn_1 = np.loadtxt('acc_1.txt')
cnn_2 = np.loadtxt('acc_2.txt')
cnn_3 = np.loadtxt('acc_3.txt')
cnn_4 = np.loadtxt('acc_4.txt')

snr = cnn_1[0,:]
cnn_1 = cnn_1[1,:]
cnn_2 = cnn_2[1,:]
cnn_3 = cnn_3[1,:]
cnn_4 = cnn_4[1,:]

MarkerSize = 6
LineWidth = 1

plt.plot(snr, cnn_1, 's-', LineWidth=LineWidth, MarkerSize=MarkerSize, label = 'stride=1')
plt.plot(snr, cnn_2, 'o-', LineWidth=LineWidth, MarkerSize=MarkerSize, label = 'stride=2')
plt.plot(snr, cnn_3, '^-', LineWidth=LineWidth, MarkerSize=MarkerSize, label = 'stride=3')
plt.plot(snr, cnn_4, 'v-', LineWidth=LineWidth, MarkerSize=MarkerSize, label = 'stride=4')

plt.grid(True)
plt.legend(loc='lower right')
plt.xlim((-10,20))
plt.ylim((0,1))
plt.xlabel('SNR(dB)')
plt.ylabel('Pc')
plt.title('')
plt.savefig('compare_curves.png', format='png')
