#!/bin/bash

if [ ! -d /home/${FIRST_USER_NAME}/.config ]; then
  mkdir -p /home/${FIRST_USER_NAME}/.config
fi
if [ ! -d /home/${FIRST_USER_NAME}/.config/lxsession ]; then
  mkdir -p /home/${FIRST_USER_NAME}/.config/lxsession
fi
if [ ! -d /home/${FIRST_USER_NAME}/.config/lxsession/LXDE-pi ]; then
  mkdir -p /home/${FIRST_USER_NAME}/.config/lxsession/LXDE-pi
fi
echo -e "@xset -dpms\n@xset s off" >> /home/${FIRST_USER_NAME}/.config/lxsession/LXDE-pi/autostart
chown -R ${FIRST_USER_NAME}:${FIRST_USER_NAME} /home/${FIRST_USER_NAME}/.config
