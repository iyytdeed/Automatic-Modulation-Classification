import numpy as np
import tensorflow as tf
import random as rn
import os

from keras import metrics, regularizers, optimizers, backend
from keras.callbacks import TensorBoard, EarlyStopping
from keras.models import Model
from keras.layers import Input, Dense, Dropout, BatchNormalization, Conv2D, Flatten, pooling
from keras.utils import np_utils, vis_utils

import scipy.io as sio

scores = np.zeros()

# fix random seed
os.environ['PYTHONHASHSEED'] = '0'
np.random.seed(2018)
rn.seed(2018)
session_conf = tf.ConfigProto(intra_op_parallelism_threads=1, inter_op_parallelism_threads=4)
tf.set_random_seed(2018)
sess = tf.Session(graph=tf.get_default_graph(), config=session_conf)
backend.set_session(sess)

seqLen = 100
nClass = 4
samNum = 100000 * nClass
# load train data
x_data_mat = sio.loadmat('./dataset/train_data.mat')
x_data_complex = x_data_mat['train_data']
x_data_real = x_data_complex.real
x_data_imag = x_data_complex.imag
x_data_real = x_data_real.reshape((samNum, seqLen, 1))
x_data_imag = x_data_imag.reshape((samNum, seqLen, 1))
x_train = np.stack((x_data_real, x_data_imag), axis=1)
y_data_mat = sio.loadmat('./dataset/train_label.mat')
y_data = y_data_mat['train_label']
y_train = np_utils.to_categorical(y_data, nClass)
# train data shuffle
index = np.arange(y_train.shape[0])
np.random.shuffle(index)
x_train = x_train[index,:]
y_train = y_train[index]

_in_ = Input(shape = (x_train.shape[1], x_train.shape[2], 1))
ot = Conv2D(filters=64, kernel_size=(2,3), strides=1, padding='valid', use_bias=True, activation='relu')(_in_)
ot = Conv2D(filters=16, kernel_size=(1,4), strides=2, padding='valid', use_bias=True, activation='relu')(ot)
ot = Flatten()(ot)
#ot = BatchNormalization(axis=-1, momentum=0.99, epsilon=0.001, center=True, scale=True)(ot)
ot = Dense(64, use_bias=True, activation='relu')(ot)
ot = Dense(16, use_bias=True, activation='relu')(ot)
_out_ = Dense(nClass, activation='softmax')(ot)
model = Model(_in_, _out_)

early_stopping = EarlyStopping(monitor='val_loss', patience=5)
adam = optimizers.Adam(lr=0.001, beta_1=0.9, beta_2=0.999, epsilon=1e-08)
model.compile(loss='categorical_crossentropy',
               optimizer=adam, 
               metrics=['categorical_accuracy'])
model.fit(x_train,
          y_train, 
          epochs=500,
          batch_size=100,
          validation_split=0.1,
          shuffle=True,
          callbacks=[early_stopping])
scores = model.evaluate(x_train, y_train)
print(" %s %f" % (model.metrics_names[1], scores[1]))
model.summary()

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
# get predict result
for i in range(y_test.shape[0]):
    axis_0 = (int)((EsNoArray[i] - EsNoLow)/Gap)
    # should be
    axis_1 = (int)(y_test[i])
    # predict to be
    axis_2 = np.argmax(y_predict[i,:])
    pred_mat[axis_0, axis_1, axis_2] = pred_mat[axis_0, axis_1, axis_2] + 1

# static sum acc
EsNoArray_attention = [0,2,4,6,8,10]
acc_sum = 0
for EsNo_t in EsNoArray_attention:
    snr[i] = EsNoLow + i*Gap
    cnt_acc = 0
    for j in range(nClass):
        cnt_acc = cnt_acc + data[i, j, j]
    acc_sum = acc_sum + cnt_acc/nb/nClass

