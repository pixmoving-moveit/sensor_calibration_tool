#!/bin/python3
import os
import yaml
import re

import numpy as np
from scipy.spatial.transform import Rotation

import logging

COLOR_RED = '\033[1;31m'
COLOR_GREEN = '\033[1;32m'
COLOR_YELLOW = '\033[1;33m'
COLOR_BLUE = '\033[1;34m'
COLOR_PURPLE = '\033[1;35m'
COLOR_CYAN = '\033[1;36m'
COLOR_GRAY = '\033[1;37m'
COLOR_RESET = '\033[0m'
LOG_FORMAT = f'{COLOR_GREEN}[%(levelname)s]{COLOR_RESET} %(message)s'
logging.basicConfig(format=LOG_FORMAT, level=logging.INFO)

class GetLidar2CameraT:
    def __init__(self):
        self.script_path = os.path.dirname(os.path.abspath(__file__))

        self.read_calibration_file()
        self.get_lidar2camera_euler_angles_t()
        self.write_json_file()


    def read_calibration_file(self):
        path = os.path.join(self.script_path, "calibration.txt")
        with open(path, 'r') as f:
            self.content = f.read()


    def get_lidar2camera_euler_angles_t(self):
        pattern = r'[-+]?\d*\.\d+|\d+'  # 匹配整数或小数
        matches = re.findall(pattern, self.content)

        # 将匹配到的数字转成浮点数，并保存到列表中
        numbers = [float(match) for match in matches]

        R = np.array([numbers[i:i+3] for i in range(0, 9, 3)])
        t = np.array(numbers[9:12])

        T = np.hstack((R, t.reshape(3, 1)))
        T = np.vstack((T, [0, 0, 0, 1]))         # 父camera-子lidar

        T_inv = np.linalg.inv(T)            # 父lidar-子camera
        rotation_matrix = T_inv[:3, :3]
        self.translation = T_inv[:3, 3].tolist()


        r = Rotation.from_matrix(rotation_matrix)
        self.euler_angles = r.as_euler('xyz', degrees=True).tolist()



    def write_json_file(self):
        path = os.path.join(self.script_path, "sensors_calibration.yaml")
        
        sensors_calibration={
            'rs162camera': {
                'x': self.translation[0],
                'y': self.translation[1],
                'z': self.translation[2],
                'roll': self.euler_angles[0],
                'pitch': self.euler_angles[1],
                'yaw': self.euler_angles[2]
            }
        }

        # sensors_calibration["rs162camera"]["x"] = self.euler_angles[0]
        # sensors_calibration["rs162camera"]["y"] = self.euler_angles[1]
        # sensors_calibration["rs162camera"]["z"] = self.euler_angles[2]

        # sensors_calibration["rs162camera"]["roll"]  = self.translation[0] 
        # sensors_calibration["rs162camera"]["pitch"] = self.translation[1] 
        # sensors_calibration["rs162camera"]["yaw"]   = self.translation[2] 

        with open(path, "w") as f:
            yaml.dump(sensors_calibration, f)

if __name__== "__main__":
    GetLidar2CameraT()
    logging.info(f'output [sensors_calibration.yaml] file')
