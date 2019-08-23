# coding=utf-8
from matplotlib import pyplot as plt
#plt.style.use("ggplot")

import json
import numpy as np
import scipy.io as sio
import tensorflow as tf

from keras import backend as K
from keras.models import model_from_json
from keras.layers import Dense, Dropout, Activation, Flatten, Embedding, LSTM, GRU, Input, RepeatVector, TimeDistributed, Lambda, Reshape
from keras.layers.convolutional import Conv2D, MaxPooling2D
from keras.utils import np_utils

import skimage.io
import skimage.transform
import skimage.filters



def draw_signal_constellation(data, row, col, n):
    plt.subplot(row, col, n)
    i_array = data[0,:]
    q_array = data[1,:]
    plt.scatter(i_array, q_array)
    plt.axis([-50,50,-50,50])

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
              
print model.summary()


# gradient ascent
def build_backprop(model, loss):
    # Gradient of the input image with respect to the loss function
    gradients = K.gradients(loss, model.input)[0]
    # Normalize the gradients
    gradients /= (K.sqrt(K.mean(K.square(gradients))) + 1e-5)
    # Keras function to calculate the gradients and loss
    return K.function([model.input], [loss, gradients])


layer = model.get_layer("conv2d_1")
plt.figure(figsize=(20,20))
for row in range(8):
    for col in range(8):
        n = 8*row+col+1
        print n
        loss_function = K.mean(model.get_layer("conv2d_1").output[:,:,:,n-1])
        backprop = build_backprop(model, loss_function)
        noise = np.random.randn(1, 2, 100, 1)
        for i in range(50):
            loss, grads = backprop([noise])
            noise += grads * .3
        draw_signal_constellation(noise.reshape(2,100,1), 8, 8, n)
#plt.show()
plt.savefig("conv2d_1_feature.png")


layer = model.get_layer("conv2d_2")
plt.figure(figsize=(20,20))
for row in range(4):
    for col in range(4):
        n = 4*row+col+1
        print n
        loss_function = K.mean(model.get_layer("conv2d_2").output[:,:,:,n-1])
        backprop = build_backprop(model, loss_function)
        noise = np.random.randn(1, 2, 100, 1)
        for i in range(50):
            loss, grads = backprop([noise])
            noise += grads * .3
        draw_signal_constellation(noise.reshape(2,100,1), 4, 4, n)
#plt.show()
plt.savefig("conv2d_2_feature.png")

