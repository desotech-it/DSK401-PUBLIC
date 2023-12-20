#!/bin/bash

ssh worker01 sudo systemctl stop kubelet > /dev/null 2>&1
sleep 60