# coding=utf-8
from matplotlib import pyplot as plt

import numpy as np
import tensorflow as tf
import random as rn
import os
import json

from keras import metrics, regularizers, optimizers, backend
from keras.callbacks import TensorBoard, EarlyStopping, ModelCheckpoint
from keras.models import Model
from keras.layers import Input, Dense, Dropout, BatchNormalization, Conv2D, Flatten, pooling
from keras.utils import np_utils, vis_utils
from keras.models import model_from_json


import scipy.io as sio

# fix random seed
os.environ['PYTHONHASHSEED'] = '0'
np.random.seed(2018)
rn.seed(2018)
#session_conf = tf.ConfigProto(intra_op_parallelism_threads=1, inter_op_parallelism_threads=4)
tf.set_random_seed(2018)
#sess = tf.Session(graph=tf.get_default_graph(), config=session_conf)
#backend.set_session(sess)


seqLen = 100
nClass = 4
samNum = 100000 * nClass
WEIGHT_FILE_PATH = 'model_weights_2.h5'


# load train data
x_data_mat = sio.loadmat('./dataset/train_rayleigh_fading_data.mat')
x_data_complex = x_data_mat['train_data']
x_data_real = x_data_complex.real
x_data_imag = x_data_complex.imag
x_data_real = x_data_real.reshape((x_data_real.shape[0], seqLen, 1))
x_data_imag = x_data_imag.reshape((x_data_imag.shape[0], seqLen, 1))
x_train = np.stack((x_data_real, x_data_imag), axis=1)
y_data_mat = sio.loadmat('./dataset/train_rayleigh_fading_label.mat')
y_data = y_data_mat['train_label']
y_train = np_utils.to_categorical(y_data, nClass)
# train data shuffle
index = np.arange(y_train.shape[0])
np.random.shuffle(index)
x_train = x_train[index,:]
y_train = y_train[index,:]
x_val = x_train[(x_train.shape[0]*999/1000-1):-1,:]
y_val = y_train[(y_train.shape[0]*999/1000-1):-1,:]
x_train = x_train[0:x_train.shape[0]*9/1000,:]
y_train = y_train[0:y_train.shape[0]*9/1000,:]


# load model
model = model_from_json(json.load(open("model_struct.json")))

# load wights
model.load_weights("./model_weights.h5")

early_stopping = EarlyStopping(monitor='val_loss', patience=10)
checkpoint = ModelCheckpoint(filepath=WEIGHT_FILE_PATH, monitor='val_loss', verbose=1, save_best_only=True)
adam = optimizers.Adam(lr=0.001, beta_1=0.9, beta_2=0.999, epsilon=1e-08)

model.compile(loss='categorical_crossentropy',
              optimizer=adam,
              metrics=['categorical_accuracy'])
his = model.fit(
          x_train,
          y_train,
          epochs=20,
          batch_size=100,
          validation_data=(x_val, y_val),
          #validation_split=0.1,
          shuffle=True,
          verbose=2,
          callbacks=[checkpoint])
          #callbacks=[early_stopping])


#scores = model.evaluate(x_train, y_train)
#print(" %s %f" % (model.metrics_names[1], scores[1]))
model.summary()
with open('model_struct_2.json', 'w') as f:
    json.dump(model.to_json(), f)

his_np = np.vstack((his.epoch, his.history['loss'], his.history['categorical_accuracy'], 
                    his.history['val_loss'], his.history['val_categorical_accuracy']))
np.savetxt('history.txt', his_np)

