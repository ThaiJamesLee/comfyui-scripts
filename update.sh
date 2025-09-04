#!/bin/bash

COMFYUI_DIR="${HOME}/ComfyUI"
COMFYUI_VENV="${HOME}/ComfyUIVenv"

cd $COMFYUI_DIR
git pull
(cd $COMFYUI_VENV && source ./bin/activate && cd $COMFYUI_DIR && pip install -r requirements.txt)

sudo systemctl restart comfyui.service
