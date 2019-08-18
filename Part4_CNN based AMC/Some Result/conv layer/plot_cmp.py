import numpy as np
import matplotlib.pyplot as plt

cnn_1L16D = np.loadtxt('acc_1L16D.txt')
cnn_1L64D = np.loadtxt('acc_1L64D.txt')
cnn_2L16D = np.loadtxt('acc_2L16D.txt')
cnn_2L64D = np.loadtxt('acc_2L64D.txt')
cnn_3L16D = np.loadtxt('acc_3L16D.txt')
cnn_3L64D = np.loadtxt('acc_3L64D.txt')

snr = cnn_1L16D[0,:]
cnn_1L16D = cnn_1L16D[1,:]
cnn_1L64D = cnn_1L64D[1,:]
cnn_2L16D = cnn_2L16D[1,:]
cnn_2L64D = cnn_2L64D[1,:]
cnn_3L16D = cnn_3L16D[1,:]
cnn_3L64D = cnn_3L64D[1,:]

MarkerSize = 6
LineWidth = 1

plt.plot(snr, cnn_1L16D, 's-', LineWidth=LineWidth, MarkerSize=MarkerSize, label = 'cnn_1L16D')
plt.plot(snr, cnn_1L64D, 'o-', LineWidth=LineWidth, MarkerSize=MarkerSize, label = 'cnn_1L64D')
plt.plot(snr, cnn_2L16D, '^-', LineWidth=LineWidth, MarkerSize=MarkerSize, label = 'cnn_2L16D')
plt.plot(snr, cnn_2L64D, 'v-', LineWidth=LineWidth, MarkerSize=MarkerSize, label = 'cnn_2L64D')
plt.plot(snr, cnn_3L16D, 'd-', LineWidth=LineWidth, MarkerSize=MarkerSize, label = 'cnn_3L16D')
plt.plot(snr, cnn_3L64D, 'p-', LineWidth=LineWidth, MarkerSize=MarkerSize, label = 'cnn_3L64D')

plt.grid(True)
plt.legend(loc='lower right')
plt.xlim((-10,20))
plt.ylim((0,1))
plt.xlabel('SNR(dB)')
plt.ylabel('Pc')
plt.title('')
plt.savefig('compare_curves.png', format='png')
