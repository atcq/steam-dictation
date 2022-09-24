#!/bin/bash

# install our whole package to this path
installer_dir=$(dirname $(readlink -f ${BASH_SOURCE:-$0}))
install_dir="$HOME/.local/share/nerd-dictation"
config_dir="$HOME/.config/nerd-dictation"
tmp_dir="/tmp/steam-dict"
local_bin="$HOME/.local/bin"

# creating temporary working directory in tmpfs
mkdir -p $tmp_dir

# get nerd-dictation from github.com/ideasman42/nerd-dictation.git
echo -e "\nCloning nerd-dictation from github to ${install_dir}.\n"
git clone https://github.com/ideasman42/nerd-dictation.git $install_dir

# get xdotool sources
echo -e "\nDownloading xdotool sources from github.\n"
wget https://github.com/jordansissel/xdotool/releases/download/v3.20211022.1/xdotool-3.20211022.1.tar.gz -P $tmp_dir
echo -e "\nExtracting sources ...\n"
tar xzf $tmp_dir/xdotool-3.20211022.1.tar.gz -C $tmp_dir
echo -e "\nMoving files to ${install_dir}...\n"
mv $tmp_dir/xdotool-3.20211022.1 $install_dir/xdotool-bin

# get basic training model for vosk
echo -e "\nDownloading basic vosk training model.\n"
wget https://alphacephei.com/kaldi/models/vosk-model-small-en-us-0.15.zip -P $tmp_dir
echo -e "\nExtrating model ...\n"
unzip -d $tmp_dir $tmp_dir/vosk-model-small-en-us-0.15.zip
# creating nerd-dict config dir and moving the model there
mkdir -p $config_dir
mv $tmp_dir/vosk-model-small-en-us-0.15 $config_dir/model

# compile the source
echo -e "\nCompiling xdotool from source!\n"
cd $install_dir/xdotool-bin/
make

# creating python venv and installing vosk
echo -e "\nCreating python venv ...\n"
cd $install_dir
python -m venv vosk
source $install_dir/vosk/bin/activate
pip install vosk

# copy helper scripts
echo -e "\nInstalling helper scripts and configs.\n"
cp $installer_dir/scripts/xdotool $install_dir
if [ ! -f $local_bin ]; then
    mkdir -p $local_bin
fi
cp $installer_dir/scripts/steam-dictation $local_bin
cp $installer_dir/scripts/steam-dict-wrapper $local_bin
cp $installer_dir/scripts/.xbindkeysrc $HOME

echo -e "\nAdding $local_bin to PATH.\n"
cat $installer_dir/scripts/local_bin >> $HOME/.bashrc
cat $installer_dir/scripts/local_bin >> $HOME/.bash_profile
cat $installer_dir/scripts/local_bin >> $HOME/.profile

xbindkeys

echo -e "\nCleaning up tmpfs.\n"
rm -rf $tmp_dir

echo -e "Installation complete (if there haven't been any errors on the way here o_O). Restart your terminal/console and try it!\nStart the dictation with: \n\n    steam-dictation begin &\n\nDictation will go to your terminal/console so you should see exactly what you're talking to yourself about, if you're finished talking to yourself, hit <Ctrl>+c and enter:\n\nsteam-dictation end\n\nto end the dictation."
