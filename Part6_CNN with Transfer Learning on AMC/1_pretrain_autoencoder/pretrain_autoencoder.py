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

import scipy.io as sio

# fix random seed
os.environ['PYTHONHASHSEED'] = '0'
np.random.seed(2018)
rn.seed(2018)
session_conf = tf.ConfigProto(intra_op_parallelism_threads=1, inter_op_parallelism_threads=4)
tf.set_random_seed(2018)
sess = tf.Session(graph=tf.get_default_graph(), config=session_conf)
backend.set_session(sess)

WEIGHT_FILE_PATH = 'model_weights.h5'
seqLen = 100
nClass = 4
samNum = 100000 * nClass


# load train data
x_data_mat = sio.loadmat('./dataset/train_data.mat')
x_data_complex = x_data_mat['train_data']
x_data_real = x_data_complex.real
x_data_imag = x_data_complex.imag
x_data_real = x_data_real.reshape((x_data_real.shape[0], seqLen, 1))
x_data_imag = x_data_imag.reshape((x_data_imag.shape[0], seqLen, 1))
x_train = np.stack((x_data_real, x_data_imag), axis=1)
y_data_mat = sio.loadmat('./dataset/train_label.mat')
y_data = y_data_mat['train_label']
y_train = np_utils.to_categorical(y_data, nClass)
# train data shuffle
index = np.arange(y_train.shape[0])
np.random.shuffle(index)
x_train = x_train[index,:]
y_train = y_train[index]
# val data
x_val = x_train[(x_train.shape[0]*9/10-1):-1,:]
y_val = y_train[(y_train.shape[0]*9/10-1):-1,:]
x_train = x_train[0:x_train.shape[0]*9/10,:]
y_train = y_train[0:y_train.shape[0]*9/10,:]

# model
_in_ = Input(shape = (x_train.shape[1], x_train.shape[2], 1))
ot = Conv2D(filters=64, kernel_size=(2,4), strides=1, padding='same', use_bias=True, activation='relu')(_in_)
ot = Conv2D(filters=16, kernel_size=(2,4), strides=1, padding='same', use_bias=True, activation='relu')(ot)
ot = Conv2D(filters=16, kernel_size=(2,4), strides=1, padding='same', use_bias=True, activation='relu')(ot)
ot = Conv2D(filters=64, kernel_size=(2,4), strides=1, padding='same', use_bias=True, activation='relu')(ot)
_out_ = Conv2D(filters=1, kernel_size=(2,4), strides=1, padding='same', use_bias=True, activation='relu')(ot)
model = Model(_in_, _out_)


tensor_board = TensorBoard(log_dir='./tensorboard_log', histogram_freq=0, write_graph=True, write_images=False,
                            embeddings_freq=0, embeddings_layer_names=None, embeddings_metadata=None)
early_stopping = EarlyStopping(monitor='val_loss', patience=10)
checkpoint = ModelCheckpoint(filepath=WEIGHT_FILE_PATH, monitor='val_loss', verbose=1, save_best_only=True)
adam = optimizers.Adam(lr=0.001, beta_1=0.9, beta_2=0.999, epsilon=1e-08)

model.compile(loss='mse',
               optimizer=adam, 
               metrics=['accuracy'])
his = model.fit(x_train,
          x_train,
          epochs=20, 
          batch_size=100,
          validation_data=(x_val, x_val),
          #validation_split=0.1,
          shuffle=True,
          verbose=2,
          callbacks=[checkpoint])
          #callbacks=[early_stopping])
          #callbacks=[tensor_board, early_stopping])
#scores = model.evaluate(x_train, y_train)
#print(" %s %f" % (model.metrics_names[1], scores[1]))
model.summary()
with open('model_struct.json', 'w') as f:
    json.dump(model.to_json(), f)

his_np = np.vstack((his.epoch, his.history['loss'], his.history['val_loss']))
np.savetxt('history.txt', his_np)

