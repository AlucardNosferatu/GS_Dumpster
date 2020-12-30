import tensorflow as tf
from tensorflow.keras.models import Model
from tensorflow.keras.layers import Dense, Input


def build_model():
    input_layer = Input(shape=(4,))
    D1 = Dense(32, activation='relu')
    D2 = Dense(32, activation='relu')
    O = Dense(4, activation='relu')
    x = D1(input_layer)
    x = D2(x)
    x = O(x)
    b_model = Model(inputs=input_layer, outputs=x)
    return b_model


if __name__ == "__main__":
    model = build_model()
    model.compile(
        optimizer=tf.keras.optimizers.Adam(0.0001),
        loss=tf.keras.losses.mse
    )
    tf.keras.utils.plot_model(model, show_shapes=True)
    model.save('Models/BOT.h5')
