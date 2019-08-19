import numpy as np
import matplotlib.pyplot as plt

EsNo = 0

L = 100
load_path = 'pred_confusion_mat_L' + str(L) + '.npy'
data = np.load(load_path)

EsNoLow = -10
EsNoHigh = 20
Gap = 2
nClass = data.shape[1]
cnt_sum = 0
for rows in data[0,:]:
    for ele in rows:
        cnt_sum = cnt_sum + ele
cnt_sum_single_class = cnt_sum/nClass

idx = (int)((EsNo-EsNoLow)/Gap)
predMat = data[idx,:]
predMat = predMat/cnt_sum_single_class
row = ['BPSK', '4QAM', '8PSK', '16QAM']
col = ['BPSK', '4QAM', '8PSK', '16QAM']

norm_conf = predMat

fig = plt.figure()
plt.clf()
ax = fig.add_subplot(111)
ax.set_aspect(1)
res = ax.imshow(norm_conf, cmap=plt.cm.gray_r, 
                interpolation='nearest')

[width, height]= norm_conf.shape

for x in xrange(width):
    for y in xrange(height):
        ax.annotate(str(norm_conf[x][y]), xy=(y, x), 
                    horizontalalignment='center',
                    verticalalignment='center')

cb = fig.colorbar(res)
plt.xticks(range(width), row)
plt.yticks(range(height), col)
savefilename = 'EsNo=' + str(EsNo) + 'dB L=' + str(L)
plt.title(savefilename)
plt.savefig(savefilename + '.png', format='png')
