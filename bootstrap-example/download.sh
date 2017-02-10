#!/bin/sh

# For minikube you would need to:
# minikube ssh
# sudo umount /Users
# sudo mount -t vboxsf -o rw,nodev,relatime,suid,dmode=600,fmode=600 Users /Users


grid-proxy-init -rfc -debug -cert grid_proxy -key grid_proxy
python download-script input.json /input