from PIL import Image
import numpy as np

im = Image.open('new.bmp')
indices = np.array(im)
ASCII_array = indices.tolist()
for ASCII_list in ASCII_array:
    string_list=[]
    for ASCII in ASCII_list:
        string_list.append(chr(ASCII))
    string=''.join(string_list)
    print(string)