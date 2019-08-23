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
from keras import backend as K

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
# memory free
x_data_mat = []
x_data_complex = []
x_data_real = []
x_data_imag = []
y_data_mat = []

# load model
base_model = model_from_json(json.load(open("model_struct.json")))
# load wights
base_model.load_weights("./model_weights.h5")
base_feature_model = Model(base_model.input, base_model.layers[2].output)
x_train_feature = base_feature_model.predict(x_train)
x_val_feature = base_feature_model.predict(x_val)
x_train = []


# trained model
_in_ = Input(shape = (x_train_feature.shape[1], x_train_feature.shape[2], x_train_feature.shape[3]))
ot = Flatten()(_in_)
ot = Dense(64, use_bias=True, activation='relu', name='dense_1_train')(ot)
ot = Dense(16, use_bias=True, activation='relu', name='dense_2_train')(ot)
_out_ = Dense(nClass, activation='softmax', name='dense_3_train')(ot)
trained_model = Model(_in_, _out_)
with open('model_struct_2.json', 'w') as f:
    json.dump(trained_model.to_json(), f)

early_stopping = EarlyStopping(monitor='val_loss', patience=10)
checkpoint = ModelCheckpoint(filepath=WEIGHT_FILE_PATH, monitor='val_loss', verbose=1, save_best_only=True)
adam = optimizers.Adam(lr=0.001, beta_1=0.9, beta_2=0.999, epsilon=1e-08)

trained_model.compile(loss='categorical_crossentropy',
              optimizer=adam,
              metrics=['categorical_accuracy'])
his = trained_model.fit(
          x_train_feature,
          y_train,
          epochs=20,
          batch_size=100,
          validation_data=(x_val_feature, y_val),
          #validation_split=0.1,
          shuffle=True,
          verbose=2,
          callbacks=[checkpoint])
          #callbacks=[early_stopping])


#scores = trained_model.evaluate(x_feature, y_train)
#print(" %s %f" % (trained_model.metrics_names[1], scores[1]))
trained_model.summary()
his_np = np.vstack((his.epoch, his.history['loss'], his.history['categorical_accuracy'], 
                    his.history['val_loss'], his.history['val_categorical_accuracy']))
np.savetxt('history.txt', his_np)


