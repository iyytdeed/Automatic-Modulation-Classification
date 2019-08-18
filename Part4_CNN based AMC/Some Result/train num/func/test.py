# coding=utf-8
from matplotlib import pyplot as plt
plt.style.use("ggplot")

import json
import numpy as np
import scipy.io as sio

from keras import backend as K
from keras.models import model_from_json
from keras.layers import Dense, Dropout, Activation, Flatten, Embedding, LSTM, GRU, Input, RepeatVector, TimeDistributed, Lambda, Reshape
from keras.layers.convolutional import Conv2D, MaxPooling2D
from keras.utils import np_utils


def draw_signal_constellation(data, row, col, n):
    plt.subplot(row, col, n)
    i_array = data[0,:]
    q_array = data[1,:]
    plt.scatter(i_array, q_array)


def draw_signal_scale(data, row, col, n):
    plt.subplot(row, col, n)
    x_array = range(data.shape[1])
    i_array = data[0,:]
    q_array = data[1,:]
    plt.plot(x_array, i_array, '-')
    plt.plot(x_array, q_array, '--')


# load model
model = model_from_json(json.load(open("model_struct.json")))

# load wights
model.load_weights("./model_weights.h5")
model.compile(loss='categorical_crossentropy',
              optimizer="adam",
              metrics=['accuracy'])

# test begin
nClass = 4
seqLen = 100
nb = 1000
EsNoLow = -10
EsNoHigh = 20
Gap = 2
pred_mat = np.zeros(((EsNoHigh-EsNoLow)/Gap+1, nClass, nClass))
# load test data
data_mat = sio.loadmat('./dataset/test_data.mat')
data_complex = data_mat['test_data']
data_real = data_complex.real
data_imag = data_complex.imag
EsNoArray = data_real[:,-1]
y_test = data_real[:,-2]
data_real = data_real[:,0:seqLen]
data_imag = data_imag[:,0:seqLen]
data_real = data_real.reshape((data_real.shape[0], seqLen, 1))
data_imag = data_imag.reshape((data_imag.shape[0], seqLen, 1))
x_test = np.stack((data_real, data_imag), axis=1)
y_predict = model.predict(x_test)

# 信号可视化
# 提取信号
target_EsNo = 20
idx_array_EsNo = np.argwhere(EsNoArray==target_EsNo)
idx_array_label = np.argwhere(y_test==0)
idx_array = np.intersect1d(idx_array_label, idx_array_EsNo)
target_bpsk = data_complex[idx_array]
target_bpsk = target_bpsk[:,0:seqLen]

idx_array_label = np.argwhere(y_test==1)
idx_array = np.intersect1d(idx_array_label, idx_array_EsNo)
target_4qam = data_complex[idx_array]
target_4qam = target_4qam[:,0:seqLen]

idx_array_label = np.argwhere(y_test==2)
idx_array = np.intersect1d(idx_array_label, idx_array_EsNo)
target_8psk = data_complex[idx_array]
target_8psk = target_8psk[:,0:seqLen]

idx_array_label = np.argwhere(y_test==3)
idx_array = np.intersect1d(idx_array_label, idx_array_EsNo)
target_16qam = data_complex[idx_array]
target_16qam = target_16qam[:,0:seqLen]

# 输入可视化
# ---bpsk begin---
target_bpsk_real = target_bpsk.real
target_bpsk_imag = target_bpsk.imag
target_bpsk_real = target_bpsk_real.reshape((target_bpsk_real.shape[0], seqLen, 1))
target_bpsk_imag = target_bpsk_imag.reshape((target_bpsk_real.shape[0], seqLen, 1))
target_bpsk_input = np.stack((target_bpsk_real,target_bpsk_imag), axis=1)

# input layer
show_num = 1
plt.figure(figsize=(10,10))
for i in range(show_num):
    data = target_bpsk_input[:,:,:,0]
    draw_signal_scale(data[i,:], 1, show_num, i+1)
#plt.show()
plt.savefig("bpsk_input_scale.png")
plt.figure(figsize=(10,10))
for i in range(show_num):
    data = target_bpsk_input[:,:,:,0]
    draw_signal_constellation(data[i,:], 1, show_num, i+1)
#plt.show()
plt.savefig("bpsk_input_constellation.png")

# first layer output
get_first_layer_output = K.function([model.layers[0].input],
                                    [model.layers[1].output])
first_layer = get_first_layer_output([target_bpsk_input[0:1,:]])[0]
first_layer = first_layer.reshape((first_layer.shape[1], first_layer.shape[2], first_layer.shape[3]))

plt.figure(figsize=(20,20))
for row in range(8):
    for col in range(8):
        n = 8*row+col+1
        plt.subplot(8, 8, n)
        x_array = range(first_layer.shape[1])
        feature_array = first_layer[:,:,n-1]
        plt.plot(x_array, feature_array[0,:], '-')
        plt.plot(x_array, feature_array[1,:], '--')
#plt.show()
plt.savefig("bpsk_first_layer_scale.png")

plt.figure(figsize=(20,20))
for row in range(8):
    for col in range(8):
        n = 8*row+col+1
        plt.subplot(8, 8, n)
        feature_array = first_layer[:,:,n-1]
        plt.scatter(feature_array[0,:], feature_array[1,:])
#plt.show()
plt.savefig("bpsk_first_layer_constellation.png")

# second layer output
get_second_layer_output = K.function([model.layers[0].input],
                                    [model.layers[2].output])
second_layer = get_second_layer_output([target_bpsk_input[0:1,:]])[0]
second_layer = second_layer.reshape((second_layer.shape[2], second_layer.shape[3]))

plt.figure(figsize=(20,20))
for row in range(4):
    for col in range(4):
        n = 4*row+col+1
        plt.subplot(4, 4, n)
        x_array = range(second_layer.shape[0])
        feature_array = second_layer[:,n-1]
        plt.plot(x_array, feature_array)
#plt.show()
plt.savefig("bpsk_second_layer_scale.png")

plt.figure(figsize=(20,20))
for row in range(4):
    for col in range(4):
        n = 4*row+col+1
        plt.subplot(4, 4, n)
        x_array = np.zeros(second_layer.shape[0])
        feature_array = second_layer[:,n-1]
        plt.scatter(feature_array, x_array)
#plt.show()
plt.savefig("bpsk_second_layer_constellation.png")
# ---bpsk end---


# ---4qam begin---
target_4qam_real = target_4qam.real
target_4qam_imag = target_4qam.imag
target_4qam_real = target_4qam_real.reshape((target_4qam_real.shape[0], seqLen, 1))
target_4qam_imag = target_4qam_imag.reshape((target_4qam_real.shape[0], seqLen, 1))
target_4qam_input = np.stack((target_4qam_real,target_4qam_imag), axis=1)

# input layer
show_num = 1
plt.figure(figsize=(10,10))
for i in range(show_num):
    data = target_4qam_input[:,:,:,0]
    draw_signal_scale(data[i,:], 1, show_num, i+1)
#plt.show()
plt.savefig("4qam_input_scale.png")
plt.figure(figsize=(10,10))
for i in range(show_num):
    data = target_4qam_input[:,:,:,0]
    draw_signal_constellation(data[i,:], 1, show_num, i+1)
#plt.show()
plt.savefig("4qam_input_constellation.png")

# first layer output
get_first_layer_output = K.function([model.layers[0].input],
                                    [model.layers[1].output])
first_layer = get_first_layer_output([target_4qam_input[0:1,:]])[0]
first_layer = first_layer.reshape((first_layer.shape[1], first_layer.shape[2], first_layer.shape[3]))

plt.figure(figsize=(20,20))
for row in range(8):
    for col in range(8):
        n = 8*row+col+1
        plt.subplot(8, 8, n)
        x_array = range(first_layer.shape[1])
        feature_array = first_layer[:,:,n-1]
        plt.plot(x_array, feature_array[0,:], '-')
        plt.plot(x_array, feature_array[1,:], '--')
#plt.show()
plt.savefig("4qam_first_layer_scale.png")

plt.figure(figsize=(20,20))
for row in range(8):
    for col in range(8):
        n = 8*row+col+1
        plt.subplot(8, 8, n)
        feature_array = first_layer[:,:,n-1]
        plt.scatter(feature_array[0,:], feature_array[1,:])
plt.savefig("4qam_first_layer_constellation.png")

# second layer output
get_second_layer_output = K.function([model.layers[0].input],
                                    [model.layers[2].output])
second_layer = get_second_layer_output([target_4qam_input[0:1,:]])[0]
second_layer = second_layer.reshape((second_layer.shape[2], second_layer.shape[3]))

plt.figure(figsize=(20,20))
for row in range(4):
    for col in range(4):
        n = 4*row+col+1
        plt.subplot(4, 4, n)
        x_array = range(second_layer.shape[0])
        feature_array = second_layer[:,n-1]
        plt.plot(x_array, feature_array)
#plt.show()
plt.savefig("4qam_second_layer_scale.png")

plt.figure(figsize=(20,20))
for row in range(4):
    for col in range(4):
        n = 4*row+col+1
        plt.subplot(4, 4, n)
        x_array = np.zeros(second_layer.shape[0])
        feature_array = second_layer[:,n-1]
        plt.scatter(feature_array, x_array)
#plt.show()
plt.savefig("4qam_second_layer_constellation.png")
# ---4qam end---


# ---8psk begin---
target_8psk_real = target_8psk.real
target_8psk_imag = target_8psk.imag
target_8psk_real = target_8psk_real.reshape((target_8psk_real.shape[0], seqLen, 1))
target_8psk_imag = target_8psk_imag.reshape((target_8psk_real.shape[0], seqLen, 1))
target_8psk_input = np.stack((target_8psk_real,target_8psk_imag), axis=1)

# input layer
show_num = 1
plt.figure(figsize=(10,10))
for i in range(show_num):
    data = target_8psk_input[:,:,:,0]
    draw_signal_scale(data[i,:], 1, show_num, i+1)
#plt.show()
plt.savefig("8psk_input_scale.png")
plt.figure(figsize=(10,10))
for i in range(show_num):
    data = target_8psk_input[:,:,:,0]
    draw_signal_constellation(data[i,:], 1, show_num, i+1)
#plt.show()
plt.savefig("8psk_input_constellation.png")

# first layer output
get_first_layer_output = K.function([model.layers[0].input],
                                    [model.layers[1].output])
first_layer = get_first_layer_output([target_8psk_input[0:1,:]])[0]
first_layer = first_layer.reshape((first_layer.shape[1], first_layer.shape[2], first_layer.shape[3]))

plt.figure(figsize=(20,20))
for row in range(8):
    for col in range(8):
        n = 8*row+col+1
        plt.subplot(8, 8, n)
        x_array = range(first_layer.shape[1])
        feature_array = first_layer[:,:,n-1]
        plt.plot(x_array, feature_array[0,:], '-')
        plt.plot(x_array, feature_array[1,:], '--')
#plt.show()
plt.savefig("8psk_first_layer_scale.png")

plt.figure(figsize=(20,20))
for row in range(8):
    for col in range(8):
        n = 8*row+col+1
        plt.subplot(8, 8, n)
        feature_array = first_layer[:,:,n-1]
        plt.scatter(feature_array[0,:], feature_array[1,:])
plt.savefig("8psk_first_layer_constellation.png")

# second layer output
get_second_layer_output = K.function([model.layers[0].input],
                                    [model.layers[2].output])
second_layer = get_second_layer_output([target_8psk_input[0:1,:]])[0]
second_layer = second_layer.reshape((second_layer.shape[2], second_layer.shape[3]))

plt.figure(figsize=(20,20))
for row in range(4):
    for col in range(4):
        n = 4*row+col+1
        plt.subplot(4, 4, n)
        x_array = range(second_layer.shape[0])
        feature_array = second_layer[:,n-1]
        plt.plot(x_array, feature_array)
#plt.show()
plt.savefig("8psk_second_layer_scale.png")

plt.figure(figsize=(20,20))
for row in range(4):
    for col in range(4):
        n = 4*row+col+1
        plt.subplot(4, 4, n)
        x_array = np.zeros(second_layer.shape[0])
        feature_array = second_layer[:,n-1]
        plt.scatter(feature_array, x_array)
#plt.show()
plt.savefig("8psk_second_layer_constellation.png")
# ---8psk end---


# ---16qam begin---
target_16qam_real = target_16qam.real
target_16qam_imag = target_16qam.imag
target_16qam_real = target_16qam_real.reshape((target_16qam_real.shape[0], seqLen, 1))
target_16qam_imag = target_16qam_imag.reshape((target_16qam_real.shape[0], seqLen, 1))
target_16qam_input = np.stack((target_16qam_real,target_16qam_imag), axis=1)

# input layer
show_num = 1
plt.figure(figsize=(10,10))
for i in range(show_num):
    data = target_16qam_input[:,:,:,0]
    draw_signal_scale(data[i,:], 1, show_num, i+1)
#plt.show()
plt.savefig("16qam_input_scale.png")
plt.figure(figsize=(10,10))
for i in range(show_num):
    data = target_16qam_input[:,:,:,0]
    draw_signal_constellation(data[i,:], 1, show_num, i+1)
#plt.show()
plt.savefig("16qam_input_constellation.png")

# first layer output
get_first_layer_output = K.function([model.layers[0].input],
                                    [model.layers[1].output])
first_layer = get_first_layer_output([target_16qam_input[0:1,:]])[0]
first_layer = first_layer.reshape((first_layer.shape[1], first_layer.shape[2], first_layer.shape[3]))

plt.figure(figsize=(20,20))
for row in range(8):
    for col in range(8):
        n = 8*row+col+1
        plt.subplot(8, 8, n)
        x_array = range(first_layer.shape[1])
        feature_array = first_layer[:,:,n-1]
        plt.plot(x_array, feature_array[0,:], '-')
        plt.plot(x_array, feature_array[1,:], '--')
#plt.show()
plt.savefig("16qam_first_layer_scale.png")

plt.figure(figsize=(20,20))
for row in range(8):
    for col in range(8):
        n = 8*row+col+1
        plt.subplot(8, 8, n)
        feature_array = first_layer[:,:,n-1]
        plt.scatter(feature_array[0,:], feature_array[1,:])
plt.savefig("16qam_first_layer_constellation.png")

# second layer output
get_second_layer_output = K.function([model.layers[0].input],
                                    [model.layers[2].output])
second_layer = get_second_layer_output([target_16qam_input[0:1,:]])[0]
second_layer = second_layer.reshape((second_layer.shape[2], second_layer.shape[3]))

plt.figure(figsize=(20,20))
for row in range(4):
    for col in range(4):
        n = 4*row+col+1
        plt.subplot(4, 4, n)
        x_array = range(second_layer.shape[0])
        feature_array = second_layer[:,n-1]
        plt.plot(x_array, feature_array)
#plt.show()
plt.savefig("16qam_second_layer_scale.png")

plt.figure(figsize=(20,20))
for row in range(4):
    for col in range(4):
        n = 4*row+col+1
        plt.subplot(4, 4, n)
        x_array = np.zeros(second_layer.shape[0])
        feature_array = second_layer[:,n-1]
        plt.scatter(feature_array, x_array)
#plt.show()
plt.savefig("16qam_second_layer_constellation.png")
# ---16qam end---


# get predict result
for i in range(y_test.shape[0]):
    axis_0 = (int)((EsNoArray[i] - EsNoLow)/Gap)
    # should be
    axis_1 = (int)(y_test[i])
    # predict to be
    axis_2 = np.argmax(y_predict[i,:])
    pred_mat[axis_0, axis_1, axis_2] = pred_mat[axis_0, axis_1, axis_2] + 1
saveFileName  = "pred_confusion_mat_L" + str(seqLen)
np.save(saveFileName, pred_mat)
