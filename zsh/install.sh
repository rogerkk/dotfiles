#!/bin/sh

echo "Setting zsh as default system shell"
sudo usermod -s /bin/zsh `whoami`
