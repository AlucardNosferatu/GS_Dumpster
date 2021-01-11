from PIL import Image
import numpy as np


def sparse_mode():
    im = Image.open('new.bmp')
    indices = np.array(im)
    ASCII_array = indices.tolist()
    for ASCII_list in ASCII_array:
        string_list = []
        for ASCII in ASCII_list:
            string_list.append(chr(ASCII))
        string = ''.join(string_list)
        print(string)


def dense_mode():
    im = Image.open('old.bmp')
    indices = np.array(im)
    data_buffer = []
    ASCII_array = indices.tolist()
    for ASCII_list in ASCII_array:
        for char_ascii in ASCII_list:
            data_buffer.append(chr(char_ascii))
    print(''.join(data_buffer))


if __name__ == '__main__':
    dense_mode()
