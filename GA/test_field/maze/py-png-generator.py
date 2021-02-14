import cv2
import numpy as np

width = 1024
length = 1024
base_map = np.zeros((width, length, 3))
base_map[:, :, 2] = 255
base_map[:, :, 1] = 250
base_map[:, :, 0] = 32
base_map[0:32, :, 2] = 255
base_map[0:32, :, 1] = 0
base_map[0:32, :, 0] = 0
base_map[:, 0:32, 2] = 255
base_map[:, 0:32, 1] = 0
base_map[:, 0:32, 0] = 0
base_map[width - 32:width, :, 2] = 255
base_map[width - 32:width, :, 1] = 0
base_map[width - 32:width, :, 0] = 0
base_map[:, length - 32:length, 2] = 255
base_map[:, length - 32:length, 1] = 0
base_map[:, length - 32:length, 0] = 0
column_count = 64
column_size = 64
for i in range(column_count):
    x = np.random.randint(0, width)
    y = np.random.randint(0, length)
    x_ub = min(x + int(column_size / 2), width)
    x_lb = max(x - int(column_size / 2), 0)
    y_ub = min(y + int(column_size / 2), length)
    y_lb = max(y - int(column_size / 2), 0)
    base_map[x_lb:x_ub, y_lb:y_ub, 2] = 64
    base_map[x_lb:x_ub, y_lb:y_ub, 1] = 0
    base_map[x_lb:x_ub, y_lb:y_ub, 0] = 0
cv2.imshow('test', base_map)
cv2.waitKey()
cv2.imwrite('test.png', base_map)
