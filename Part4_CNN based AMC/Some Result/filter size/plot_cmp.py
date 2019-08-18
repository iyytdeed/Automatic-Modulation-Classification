import numpy as np
import matplotlib.pyplot as plt

cnn_2 = np.loadtxt('acc_2.txt')
cnn_4 = np.loadtxt('acc_4.txt')
cnn_8 = np.loadtxt('acc_8.txt')
cnn_16 = np.loadtxt('acc_16.txt')

snr = cnn_2[0,:]
cnn_2 = cnn_2[1,:]
cnn_4 = cnn_4[1,:]
cnn_8 = cnn_8[1,:]
cnn_16 = cnn_16[1,:]

MarkerSize = 6
LineWidth = 1

plt.plot(snr, cnn_2, 's-', LineWidth=LineWidth, MarkerSize=MarkerSize, label = 'filter size=2')
plt.plot(snr, cnn_4, 'o-', LineWidth=LineWidth, MarkerSize=MarkerSize, label = 'filter size=4')
plt.plot(snr, cnn_8, '^-', LineWidth=LineWidth, MarkerSize=MarkerSize, label = 'filter size=8')
plt.plot(snr, cnn_16, 'v-', LineWidth=LineWidth, MarkerSize=MarkerSize, label = 'filter size=16')

plt.grid(True)
plt.legend(loc='lower right')
plt.xlim((-10,20))
plt.ylim((0,1))
plt.xlabel('SNR(dB)')
plt.ylabel('Pc')
plt.title('')
plt.savefig('compare_curves.png', format='png')
