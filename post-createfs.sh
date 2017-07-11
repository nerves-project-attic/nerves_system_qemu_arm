#!/bin/sh

set -e

FWUP_CONFIG=$NERVES_DEFCONFIG_DIR/fwup.conf

# Strip u-boot since it gets copied w/ symbols by default
# and the symbols can get really large
$HOST_DIR/usr/bin/arm-unknown-linux-gnueabihf-strip $BINARIES_DIR/u-boot

# Run the common post-image processing for nerves
$BR2_EXTERNAL_NERVES_PATH/board/nerves-common/post-createfs.sh $TARGET_DIR $FWUP_CONFIG
