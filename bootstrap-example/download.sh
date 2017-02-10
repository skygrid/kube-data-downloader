#!/bin/sh

grid-proxy-init -rfc -debug -cert grid_proxy -key grid_proxy
./download-script input.json /input