import re
import numpy as np
import tensorflow as tf
import xml.etree.ElementTree as ET
from tqdm import tqdm
from tensorflow.keras.models import Model
from tensorflow.keras.layers import Dense, Input, Activation


def build_model():
    input_layer = Input(shape=(16,))
    D1 = Dense(32, activation='relu')
    D2 = Dense(16, activation='relu')
    D3 = Dense(8, activation='relu')
    O = Dense(4, activation='sigmoid')
    x = D1(input_layer)
    x = D2(x)
    x = D3(x)
    x= O(x)
    b_model = Model(inputs=input_layer, outputs=x)
    return b_model


def process_weight(w, name):
    Mat = ET.Element('matrix', {})
    WeightTree = ET.ElementTree(Mat)
    for i in range(w.shape[0]):
        Row = ET.SubElement(Mat, 'row', {'number': 'row-' + str(i)})  # 设置 value值
        y = str(w[i, :])
        y = re.sub('\\[', '', y)
        y = re.sub('\\]', '', y)
        y = y.replace('\n', ' ')
        Row.text = y
    WeightTree.write('addons/amxmodx/data/models/TTD/' + name + '_weight.xml')


def process_bias(b, name):
    Mat = ET.Element('bias')
    WeightTree = ET.ElementTree(Mat)
    y = str(b)
    y = re.sub('\\[', '', y)
    y = re.sub('\\]', '', y)
    y = y.replace('\n', ' ')
    Mat.text = y
    WeightTree.write('addons/amxmodx/data/models/TTD/' + name + '_bias.xml')


def weight_to_xml(model):
    allow_type = [
        tf.keras.layers.Dense
    ]
    for layer in model.layers:
        if type(layer) in allow_type:
            w, b = layer.get_weights()
            process_weight(w, layer.name)
            process_bias(b, layer.name)


def gen_data_pair():
    src_data = np.random.randint(2, high=10, size=16, dtype='l')
    src_data = src_data.astype(np.float)
    max_data = np.max(src_data) / 10
    min_data = np.min(src_data) / 10
    ave_data = np.mean(src_data) / 10
    var_data = np.var(src_data) / 10
    out_data = np.array([max_data, min_data, ave_data, var_data])
    return src_data, out_data


def gen_data_batch(batch_count, batch_size):
    x_list = []
    y_list = []
    for i in tqdm(range(batch_size * batch_count)):
        x, y = gen_data_pair()
        x_list.append(x)
        y_list.append(y)
    x_batch = np.array(x_list)
    y_batch = np.array(y_list)
    return x_batch, y_batch


def build_and_train():
    batch_count = 10000
    batch_size = 32
    x, y = gen_data_batch(batch_count, batch_size)
    model = build_model()
    model.compile(
        optimizer=tf.keras.optimizers.Adam(0.0001),
        loss=tf.keras.losses.mse
    )
    model.fit(x=x, y=y, batch_size=batch_size, epochs=10)
    tf.keras.utils.plot_model(model, show_shapes=True)
    weight_to_xml(model)
    model.save('addons/amxmodx/data/models/TTD.h5')


def load_and_train():
    batch_count = 10000
    batch_size = 32
    x, y = gen_data_batch(batch_count, batch_size)
    model = tf.keras.models.load_model('addons/amxmodx/data/models/TTD.h5')
    model.fit(x=x, y=y, batch_size=batch_size, epochs=10)
    tf.keras.utils.plot_model(model, show_shapes=True)
    weight_to_xml(model)
    model.save('addons/amxmodx/data/models/TTD.h5')


def load_and_test():
    model = tf.keras.models.load_model('addons/amxmodx/data/models/TTD.h5')
    for i in range(10):
        x, y = gen_data_batch(1, 2)
        y_ = model.predict(x)
        print(y)
        print(y_)
        print('==========================')


if __name__ == "__main__":
    # load_and_train()
    load_and_test()
