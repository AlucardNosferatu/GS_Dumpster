from PIL import Image
import numpy as np


def sparse_mode(data):
    string_list = data.split('\n')
    ASCII_array = []
    for sentence in string_list:
        if len(ASCII_array) < 112:
            ASCII_list = []
            for char in sentence:
                ASCII_list.append(ord(char))
            while len(ASCII_list) < 128:
                ASCII_list.append(ord(' '))
            if len(ASCII_list) > 128:
                print('too much chars in a line, will truncate this line')
                ASCII_list = ASCII_list[:128]
            ASCII_array.append(ASCII_list)
        else:
            print('too much lines')
    while len(ASCII_array) < 112:
        ASCII_list = [ord(' ')] * 128
        ASCII_array.append(ASCII_list)
    return ASCII_array


def dense_mode(data):
    if len(data) > 128 * 112:
        data = data[:128 * 112]
        print('Warning! Text size exceeds 128*112, will truncate it!')
    ASCII_array = []
    ASCII_list = []
    for index, char in enumerate(data):
        if not char.isascii():
            char = "?"
        ASCII_list.append(ord(char))
        while index == len(data) - 1 and len(ASCII_list) < 128:
            ASCII_list.append(ord(' '))
        if len(ASCII_list) >= 128:
            ASCII_array.append(ASCII_list)
            ASCII_list = []
    while len(ASCII_array) < 112:
        ASCII_list = [ord(' ')] * 128
        ASCII_array.append(ASCII_list)
    return ASCII_array


def to_bmp(ascii_array):
    indexed_new = np.array(ascii_array, dtype=np.uint8)
    im = Image.fromarray(indexed_new)
    palette_new = []
    for i in range(256):
        palette_new += [255 - i, i, 255]
    im.putpalette(palette_new)
    im.save('old.bmp')
    print('Done')


if __name__ == '__main__':
    with open("CPlayerClassUtil.as", "r", encoding='utf-8') as f:  # 打开文件
        data = f.read()
        array = dense_mode(data)
        to_bmp(array)
