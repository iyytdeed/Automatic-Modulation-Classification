import numpy as np
import matplotlib.pyplot as plt

#plt.style.use("ggplot")

acc_1k = np.loadtxt('acc_1k.txt')
acc_3k = np.loadtxt('acc_3k.txt')
acc_10k = np.loadtxt('acc_10k.txt')
acc_30k = np.loadtxt('acc_30k.txt')
acc_100k = np.loadtxt('acc_100k.txt')

snr = acc_1k[0,:]
acc_1k = acc_1k[1,:]
acc_3k = acc_3k[1,:]
acc_10k = acc_10k[1,:]
acc_30k = acc_30k[1,:]
acc_100k = acc_100k[1,:]

MarkerSize = 6
LineWidth = 1

plt.plot(snr, acc_1k, 's-', linewidth=LineWidth, markersize=MarkerSize, label='$N_{sample}$=1k')
plt.plot(snr, acc_3k, 'd-', linewidth=LineWidth, markersize=MarkerSize, label='$N_{sample}$=3k')
plt.plot(snr, acc_10k, 'o-', linewidth=LineWidth, markersize=MarkerSize, label='$N_{sample}$=10k')
plt.plot(snr, acc_30k, '^-', linewidth=LineWidth, markersize=MarkerSize, label='$N_{sample}$=30k')
plt.plot(snr, acc_100k, 'v-', linewidth=LineWidth, markersize=MarkerSize, label='$N_{sample}$=100k')

plt.grid(True)
plt.legend(loc='lower right')
plt.xlim((-10,20))
plt.ylim((0,1))
plt.xlabel('SNR(dB)')
plt.ylabel('Pc')
plt.title('')
plt.savefig('compare_curves.png', format='png')
