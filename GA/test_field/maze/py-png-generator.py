import cv2
import numpy as np

p_collision = [48, 48, 96]
p_collision_duck = [48, 48, 48]
collision_size = 48
width = 1024
length = 1024
grid_stride_w = 64
grid_stride_l = 64
grid_max_w = int(width / grid_stride_w)
grid_max_l = int(length / grid_stride_l)
base_map = np.zeros((width, length, 3))
base_map[:, :, 2] = 255
base_map[:, :, 1] = 250
base_map[:, :, 0] = 32
column_count = 96
column_size = 64
for i in range(column_count):
    x = np.random.randint(0, grid_max_w)*64
    y = np.random.randint(0, grid_max_l)*64
    x_ub = min(x + int(column_size / 2), width)
    x_lb = max(x - int(column_size / 2), 0)
    y_ub = min(y + int(column_size / 2), length)
    y_lb = max(y - int(column_size / 2), 0)
    base_map[x_lb:x_ub, y_lb:y_ub, 0] = 128
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
cv2.imshow('test', base_map)
cv2.waitKey()
cv2.imwrite('test.png', base_map)
