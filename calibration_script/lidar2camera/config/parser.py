#!/bin/python3
import os
import yaml
import json
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

class ParserYaml:
    def __init__(self):
        self.script_path = os.path.dirname(os.path.abspath(__file__))

        self.read_camera_intrinsic_file()
        self.revise_camera_intrinsic()
        self.write_json_file()


    def read_camera_intrinsic_file(self):
        path = os.path.join(self.script_path, "ost.yaml")
        with open(path, "r") as f:
            self.ost_yaml = yaml.load(f, Loader=yaml.FullLoader)

        path = os.path.join(self.script_path, "..", "..", "lidar2camera", "config", "center_camera-intrinsic.json")
        with open(path, 'r') as f:
            self.center_camera_intrinsic = json.load(f)    

    def revise_camera_intrinsic(self):
        

        self.center_camera_intrinsic["center_camera-intrinsic"]["param"]["img_dist_w"] = \
        self.ost_yaml["image_width"]

        self.center_camera_intrinsic["center_camera-intrinsic"]["param"]["img_dist_h"] = \
        self.ost_yaml["image_height"]

        self.center_camera_intrinsic["center_camera-intrinsic"]["param"]["cam_K"]["data"] = \
        [self.ost_yaml["camera_matrix"]["data"][i:i+3] for i in range(0, 9, 3)]

        self.center_camera_intrinsic["center_camera-intrinsic"]["param"]["cam_dist"]["data"][0] = \
        self.ost_yaml["distortion_coefficients"]["data"][0:4]


    
    def write_json_file(self):
        path = os.path.join(self.script_path, "..", "..", "lidar2camera", "config", "center_camera-intrinsic.json")
        with open(path, "w") as f:
            json.dump(self.center_camera_intrinsic, f, indent=4)

if __name__== "__main__":
    yaml2json = ParserYaml()
    logging.info(f'convert network:')
