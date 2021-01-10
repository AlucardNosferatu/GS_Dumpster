from PIL import Image
import numpy as np

with open("UREnhanced.as", "r") as f:  # 打开文件
    data = f.read()

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
    ASCII_list = [ord(' ')]*128
    ASCII_array.append(ASCII_list)

indexed_new = np.array(ASCII_array, dtype=np.uint8)
im = Image.fromarray(indexed_new)
palette_new = []
for i in range(256):
    palette_new += [255 - i, i, 255]
im.putpalette(palette_new)

im.save('old.bmp')
print('Done')
