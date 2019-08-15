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


# Loss function that optimizes one class
label_index = 3
loss_function = K.mean(model.get_layer("dense_3").output[:,label_index])

# Backprop function
backprop = build_backprop(model, loss_function)

# gen noise
noise = np.random.randn(1, 2, 100, 1)
#draw_signal_constellation(noise.reshape(2,100,1), 1, 1, 1)

# Iteratively apply gradient ascent
for i in range(50):
    loss, grads = backprop([noise])
    # Multiply gradients by the learning rate and add to the image
    # Optionally, apply a gaussian filter to the gradients to smooth
    # out the generated image. This gives better results.
    # The first line, which is commented out, is the native method
    # and the following line uses the filter. Try with both to
    # see the difference.
    #
    noise += grads * .01
    #shape = grads.shape
    #grads = grads.squeeze()
    #grads = skimage.filters.gaussian(np.clip(grads, -1, 1), 2)
    #grads = grads.reshape(shape)
    #noise += grads
    # Print loss value
    if i % 10 == 0:
        print('Loss:', loss)
    
#pdt = model.predict(noise)
#print pdt
draw_signal_constellation(noise.reshape(2,100,1), 1, 1, 1)
#plt.show()
plt.axis([-3,3,-3,3])
plt.savefig("16qam_feature.png")
