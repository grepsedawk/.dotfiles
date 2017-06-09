version=1.3.2421
cd /tmp
wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-${version}.tar.gz
tar zxf jetbrains-toolbox-${version}.tar.gz
mkdir -p $HOME/.bin/
mv jetbrains-toolbox-${version}/jetbrains-toolbox ~/.bin/

