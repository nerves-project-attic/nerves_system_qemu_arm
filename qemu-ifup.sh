#!/bin/bash
case $OSTYPE in
  darwin*)
    ifconfig bridge1 addm "$1"
    ;;
esac
