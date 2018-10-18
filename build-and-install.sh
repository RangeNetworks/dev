#!/bin/bash

source $(dirname $0)/common.source

SDR=$1
ROOT=`pwd`

usage () {
    echo "#  - Usage: $0 radio-type"
    echo "#  - Valid radio types are: SDR1, USRP1, B100, B110, B200, B210, N200, N210"
    exit 1
}

if [ "$EUID" -ne 0 ]
  then echo "# - $(whoami) please run me as root"
  # sudo $0 $SDR
  exit 1
fi

if [ -z "$SDR" ]; then
  echo "# - ERROR : radio type must be specified"
  usage
  exit 1
fi

./clone.sh
./build.sh $SDR asterisk
./build.sh $SDR liba53

cd ${ROOT}/libcoredumper
./build.sh LOCAL
sayAndDo "dpkg -i libcoredumper1_1.2.1-1_*.deb"
sayAndDo "dpkg -i libcoredumper-dev_1.2.1-1_*.deb"

cd $ROOT
./build.sh $SDR subscriberRegistry
./build.sh $SDR smqueue
./build.sh $SDR openbts
./build.sh $SDR asterisk-config

sayAndDo "find BUILDS -name range-asterisk_11.7.0.5_*.deb -exec dpkg -i {} \;"
sayAndDo "find BUILDS -name liba53_0.1_*.deb -exec dpkg -i {} \;"
sayAndDo "find BUILDS -name smqueue_5.0_*.deb -exec dpkg -i {} \;"
sayAndDo "find BUILDS -name openbts_5.0_*.deb -exec dpkg -i {} \;"
sayAndDo "find BUILDS -name range-asterisk-config_5.0_all.deb -exec dpkg -i {} \;"

sayAndDo cp systemd-service-units-configuration/asterisk.service /etc/systemd/system/
sayAndDo cp systemd-service-units-configuration/sipauthserve.service /etc/systemd/system/
sayAndDo cp systemd-service-units-configuration/smqueue.service /etc/systemd/system/
sayAndDo cp systemd-service-units-configuration/openbts.service /etc/systemd/system/
sayAndDo systemctl daemon-reload

sayAndDo cp ./NodeManager/nmcli.py /OpenBTS/
sayAndDo chown -R asterisk:www-data /var/lib/asterisk

exit 0
