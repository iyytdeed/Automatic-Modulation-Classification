# coding=utf-8
from matplotlib import pyplot as plt

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


# conv2D_1 vistualization
layer = model.layers[1]
weights = layer.get_weights()[0] # list, [weights, weights_bias]
plt.figure(figsize=(20,20))
for row in range(8):
    for col in range(8):
        n = 8*row+col+1
        plt.subplot(8, 8, n)
        plt.imshow(weights[:,:,:,n-1].squeeze(), cmap='gray')
#plt.show()
plt.savefig("conv2D_1_weights.png")

# conv2D_2 vistualization
layer = model.layers[2]
weights = layer.get_weights()[0]
plt.figure(figsize=(20,20))
for row in range(4):
    for col in range(4):
        n = 4*row+col+1
        plt.subplot(4, 4, n)
        plt.imshow(weights[:,:,:,n-1], cmap='gray')
plt.savefig("conv2D_2_weights.png")
