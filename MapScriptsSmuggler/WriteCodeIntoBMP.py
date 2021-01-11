import os

from PIL import Image
import numpy as np

line_const = []
for i in range(7):
    line_const.append(16 * (i + 1))


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


def remove_comments(data):
    data = data.replace('\n\n', '\n')
    data = data.replace('\n\n', '\n')
    data = data.replace(' =', '=')
    data = data.replace('= ', '=')
    data = data.replace(' \n', '\n')
    data = data.replace(' \n', '\n')
    data = data.replace(', ', ',')
    data = data.replace(' )', ')')
    data = data.replace('( ', '(')
    data = data.replace('else\n', 'else')
    lines = data.split('\n')
    blacklist = []
    for index, line in enumerate(lines):
        lines[index] = line.strip()
        if line.strip().startswith('//') or len(line.strip()) == 0:
            blacklist.append(index)
        elif '//' in line:
            lines[index] = line.split('//')[0]
    blacklist.sort(reverse=True)
    for comment_line_index in blacklist:
        lines.pop(comment_line_index)
    data = '\n'.join(lines)
    return data


def dense_mode(data, fname_for_optimize):
    if len(data) > 128 * 112:
        print('Warning! Text size ' + str(len(data)) + ' exceeds ' + str(128 * 112))
        print('Will optimize it (may corrupt functions)!')
        data_new = remove_comments(data)
        if len(data_new) > 128 * 112:
            print('Warning! Text size ' + str(len(data)) + ' still exceeds ' + str(128 * 112))
            print('Will truncate it! (100% unusable)')
            data = data[:128 * 112]
        else:
            data = data_new
            with open(fname_for_optimize.replace('.as', '_optimized.as'), "w", encoding='utf-8') as f:  # 打开文件
                f.write(data)
            print('Optimization has completed. New file size: ' + str(len(data)))
            print('Plz check optimized file!')
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
    for line_count in line_const:
        if len(ASCII_array) <= line_count:
            while len(ASCII_array) < line_count:
                ASCII_list = [ord(' ')] * 128
                ASCII_array.append(ASCII_list)
            break
    return ASCII_array


def to_bmp(ascii_array, name):
    file_path = os.path.join('Output Codes', name)
    indexed_new = np.array(ascii_array, dtype=np.uint8)
    im = Image.fromarray(indexed_new)
    palette_new = []
    for i in range(256):
        palette_new += [255 - i, i, 255]
    im.putpalette(palette_new)
    im.save(file_path.replace('.as', '_as.bmp').replace('.cfg', '_cfg.bmp'))
    print('Done')


if __name__ == '__main__':
    file_list = os.listdir('Input Codes')
    for file in file_list:
        if file.endswith('.as') or file.endswith('.cfg'):
            # if file == 'monster_electro.as':
            file_path = os.path.join('Input Codes', file)
            print(file_path)
            with open(file_path, "r", encoding='utf-8') as f:  # 打开文件
                data = f.read()
                array = dense_mode(data, file)
                to_bmp(array, file)
