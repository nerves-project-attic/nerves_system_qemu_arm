#!/bin/bash
case $OSTYPE in
  darwin*)
    ifconfig bridge1 deletem "$1"
    ;;
esac
