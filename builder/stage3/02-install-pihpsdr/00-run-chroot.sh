#!/bin/bash

# Get piHPSDR setup wizard
DIR_TMP=$(mktemp -d)
curl --insecure -o ${DIR_TMP}/pihpsdr.tar https://raw.githubusercontent.com/g0orx/pihpsdr/master/release/pihpsdr.tar
tar -xvf ${DIR_TMP}/pihpsdr.tar -C ${DIR_TMP}

# Install piHPSDR binary
mv ${DIR_TMP}/pihpsdr/pihpsdr /usr/local/bin
chmod 755 /usr/local/bin/pihpsdr

# Install piHPSDR udev rules
mv ${DIR_TMP}/pihpsdr/*.rules /etc/udev/rules.d

# Install piHPSDR libraries
mv ${DIR_TMP}/pihpsdr/libwdsp.so /usr/local/lib
mv ${DIR_TMP}/pihpsdr/libLimeSuite.so.19.04.1 /usr/local/lib
mv ${DIR_TMP}/pihpsdr/libSoapySDR.so.0.8.0 /usr/local/lib
mv ${DIR_TMP}/pihpsdr/SoapySDR /usr/local/lib
cd /usr/local/lib
ln -s libLimeSuite.so.19.04.1 libLimeSuite.so.19.04-1
ln -s libLimeSuite.so.19.04-1 libLimeSuite.so
ln -s libSoapySDR.so.0.8.0 libSoapySDR.so.0.8
ln -s libSoapySDR.so.0.8 libSoapySDR.so
ldconfig

# Create piHPSDR desktop shortcut
mkdir -p /home/${FIRST_USER_NAME}/.pihpsdr /home/${FIRST_USER_NAME}/Desktop
cat <<EOF > /home/${FIRST_USER_NAME}/.pihpsdr/start_pihpsdr.sh
cd /home/${FIRST_USER_NAME}/.pihpsdr
/usr/local/bin/pihpsdr >log 2>&1
EOF
mv ${DIR_TMP}/pihpsdr/hpsdr_icon.png /home/${FIRST_USER_NAME}/.pihpsdr
cat <<EOF > /home/${FIRST_USER_NAME}/Desktop/pihpsdr.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Name[eb_GB]=piHPSDR
Exec=/home/${FIRST_USER_NAME}/.pihpsdr/start_pihpsdr.sh
Icon=/home/${FIRST_USER_NAME}/.pihpsdr/hpsdr_icon.png
Name=piHPSDR
EOF
if [ ! -d /home/${FIRST_USER_NAME}/.local ]; then
  mkdir /home/${FIRST_USER_NAME}/.local
fi
if [ ! -d /home/${FIRST_USER_NAME}/.local/share ]; then
  mkdir /home/${FIRST_USER_NAME}/.local/share
fi
if [ ! -d /home/${FIRST_USER_NAME}/.local/share/applications ]; then
  mkdir /home/${FIRST_USER_NAME}/.local/share/applications
fi
cp /home/${FIRST_USER_NAME}/Desktop/pihpsdr.desktop /home/${FIRST_USER_NAME}/.local/share/applications
chown -R ${FIRST_USER_NAME}:${FIRST_USER_NAME} /home/${FIRST_USER_NAME}
chmod 755 -R /home/${FIRST_USER_NAME}/.pihpsdr/*.sh /home/${FIRST_USER_NAME}/Desktop
rm -rf ${DIR_TMP}


