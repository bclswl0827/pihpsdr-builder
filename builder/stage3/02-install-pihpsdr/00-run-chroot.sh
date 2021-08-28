#!/bin/bash

# Get piHPSDR setup wizard
DIR_TMP=$(mktemp -d)
curl --insecure -o ${DIR_TMP}/pihpsdr.tar https://raw.githubusercontent.com/g0orx/pihpsdr/master/release/pihpsdr.tar
tar -xvf ${DIR_TMP}/pihpsdr/pihpsdr.tar -C ${DIR_TMP}

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
mkdir -p /home/${FIRST_USER_NAME}/.pihpsdr
cat <<EOF > /home/${FIRST_USER_NAME}/.pihpsdr/start_pihpsdr.sh
cd `pwd`
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
Exec=/home/${USER}/.pihpsdr/start_pihpsdr.sh
Icon=/home/${USER}/.pihpsdr/hpsdr_icon.png
Name=piHPSDR
EOF
chown -R ${FIRST_USER_NAME}:${FIRST_USER_NAME} /home/${FIRST_USER_NAME}
chmod 755 -R /home/${FIRST_USER_NAME}/.pihpsdr/*.sh
chmod 755 -R /home/${FIRST_USER_NAME}/Desktop/*.desktop
rm -rf ${DIR_TMP}

# Switch to default user
su ${FIRST_USER_NAME}
if [ ! -d ~/.local ]; then
  mkdir ~/.local
fi
if [ ! -d ~/.local/share ]; then
  mkdir ~/.local/share
fi
if [ ! -d ~/.local/share/applications ]; then
  mkdir ~/.local/share/applications
fi
cp ~/Desktop/pihpsdr.desktop ~/.local/share/applications
exit
