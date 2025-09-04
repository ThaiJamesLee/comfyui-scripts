#!/bin/bash

# This script requires you to have python >= 3.12 and pip installed.
# Try by running "python3 --version" and "pip3 --version"
COMFYUI_DIR="${HOME}/ComfyUI"
COMFYUI_VENV="${HOME}/ComfyUIVenv"

# Download repository
cd $HOME
git clone https://github.com/comfyanonymous/ComfyUI.git

# Create venv
mkdir "ComfyUIVenv"
python3 -m venv $COMFYUI_VENV
# Activate venv
source "${COMFYUI_VENV}/bin/activate"

# Install pytorch. Change this to your needs. We are using Cuda 12.6 here because we are using a GTX 1080TI.
# See: https://github.com/comfyanonymous/ComfyUI?tab=readme-ov-file#manual-install-windows-linux
pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu126

# Install dependencies
(cd $COMFYUI_DIR && pip3 install -r requirements.txt)

# Install custom nodes
(cd "${COMFYUI_DIR}/custom_nodes" && git clone https://github.com/ltdrdata/ComfyUI-Manager comfyui-manager)
(cd "${COMFYUI_DIR}/custom_nodes" && git clone https://github.com/hayden-fr/ComfyUI-Image-Browsing.git)

# Create execution binary
EXEC_SCRIPT="""
#!/bin/bash

source ${COMFYUI_VENV}/bin/activate
(cd ${COMFYUI_DIR} && python3 main.py --listen)
"""
sudo echo $EXEC_SCRIPT > /usr/bin/comfyui
sudo chmod +x /usr/bin/comfyui

# Create systemd service
SERVICE_DEF="""
[Unit]
Description=ComfyUI

[Service]
Type=simple
Restart=always
RestartSec=1
ExecStart=/usr/bin/comfyui

[Install]
WantedBy=multi-user.target
"""
sudo echo $SERVICE_DEV > /etc/systemd/system/comfyui.service

# Start and enable service. 
# The service will be automatically started on boot.
sudo systemctl start comfyui.service
sudo systemctl enable comfyui.service

# Show the status of the service
sudo systemctl status comfyui.service
