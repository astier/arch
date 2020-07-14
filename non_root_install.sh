#!/usr/bin/env sh

mkdir -p projects
cd ~/projects

git clone https://github.com/astier/dotfiles
git clone https://github.com/astier/scripts
git clone https://github.com/astier/st
git clone https://github.com/daniruiz/flat-remix
git clone https://github.com/horst3180/arc-theme
git clone https://github.com/neovim/neovim

cd dotfiles && sh setup.sh
cd ../scripts && sh setup.sh
cd ../st && make install clean

cd ../neovim && git checkout stable
make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=$HOME/.local install
pip3 install --user neovim-remote
# sudo sed -i '/shortmess/d' /usr/lib/python3.8/site-packages/nvr/nvr.py

cd ../arc-theme
./autgen.sh --prefix=$HOME/.local
make install

mkdir ~/.local/share/icons
cp ../flat-remix/Flat-Remix-Blue-Dark ~/.local/share/icons
