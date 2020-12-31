import tensorflow as tf
from tensorflow.keras.models import Model
from tensorflow.keras.layers import Dense, Input


def build_model():
    input_dims = 2
    # hp & frags: 2 params
    input_dims += 1
    # ranged enemies count: 1 param
    input_dims += 1
    # ranged enemies ave distance/range radius: 1 param
    input_dims += 1
    # nearest enemies health/full health: 1 param
    input_dims += 3
    # nearest enemies direction: 3 params
    input_dims += 1
    # second nearest enemies health/full health: 1 param
    input_dims += 3
    # second nearest enemies direction: 3 params
    input_dims += 1
    # third nearest enemies health/full health: 1 param
    input_dims += 3
    # third nearest enemies direction: 3 params
    input_layer = Input(shape=(input_dims,))
    D1 = Dense(32, activation='relu')
    D2 = Dense(32, activation='relu')
    output_dims = 1
    # move or not: 1 param
    output_dims += 3
    # move to (direction): 3 params
    output_dims += 1
    # shoot or not: 1 param
    output_dims += 3
    # face to (direction): 3 params
    output_dims += 1
    # jump or not: 1 param
    output_dims += 1
    # reload or not: 1 param

    O = Dense(output_dims, activation='relu')
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
