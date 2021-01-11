import os

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


def dense_mode(file_path='old.bmp'):
    im = Image.open(file_path)
    indices = np.array(im)
    data_buffer = []
    ASCII_array = indices.tolist()
    for ASCII_list in ASCII_array:
        for char_ascii in ASCII_list:
            data_buffer.append(chr(char_ascii))
    return ''.join(data_buffer)


def to_text(data, bmp_name):
    if bmp_name.endswith('_as.bmp'):
        with open(bmp_name.replace('_as.bmp', '.as'), "w", encoding='utf-8') as f:  # 打开文件
            f.write(data)
    elif bmp_name.endswith('_cfg.bmp'):
        with open(bmp_name.replace('_cfg.bmp', '.cfg'), "w", encoding='utf-8') as f:  # 打开文件
            f.write(data)


if __name__ == '__main__':
    if __name__ == '__main__':
        file_list = os.listdir('Output Codes')
        for file in file_list:
            if file.endswith('.bmp'):
                file_path = os.path.join('Output Codes', file)
                print(file_path)
                data_buffer = dense_mode(file_path)
                to_text(data_buffer, file_path)
