import re
import tensorflow as tf
import xml.etree.ElementTree as ET
from tensorflow.keras.models import Model
from tensorflow.keras.layers import Dense, Input


def build_model():
    input_layer = Input(shape=(16,))
    D1 = Dense(32, activation='relu')
    D2 = Dense(16, activation='relu')
    D3 = Dense(8, activation='relu')
    O = Dense(4, activation='sigmoid')
    x = D1(input_layer)
    x = D2(x)
    x = D3(x)
    x = O(x)
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


if __name__ == "__main__":
    model = build_model()
    model.compile(
        optimizer=tf.keras.optimizers.Adam(0.0001),
        loss=tf.keras.losses.mse
    )
    weight_to_xml(model)
    tf.keras.utils.plot_model(model, show_shapes=True)
    model.save('addons/amxmodx/data/models/TTD.h5')
