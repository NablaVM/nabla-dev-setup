
#
#   Get the path and make sure that the path exists
#
read -p  "Please enter the directory to set everything up in : " nablaPath

if [ -d "${nablaPath}" ] 
then
    while true; do
        read -p "Directory \"${nablaPath}\" already exists. Would you like to continue ? (y/n) : " yn
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
else
    while true; do
        read -p "Directory \"${nablaPath}\" does not exists. Would you like to create it ? (y/n) : " yn
        case $yn in
            [Yy]* ) mkdir -p ${nablaPath} ; break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
fi

#
#   Clone everything into place
#
cd "${nablaPath}"

mkdir builds

git clone https://github.com/NablaVM/libnabla 
git clone https://github.com/NablaVM/solace 
git clone https://github.com/NablaVM/nabla 
git clone https://github.com/NablaVM/del

cd builds
mkdir nabla
mkdir solace
mkdir libnabla
mkdir del

#
#   Write a build script
#
cat <<EOT >> build-all.sh
cd ${nablaPath}/builds/libnabla
cmake ${nablaPath}/libnabla/lib
make -j9

sudo make install

cd ${nablaPath}/builds/solace
cmake ${nablaPath}/solace/src
make -j9

cd ${nablaPath}/builds/nabla
cmake ${nablaPath}/nabla/src
make -j9

cd ${nablaPath}/builds/del
cmake ${nablaPath}/del/src
make -j9

cd ${nablaPath}/builds
EOT

chmod +x build-all.sh

echo -e "\n\nEverything is all set. You can now find the nabla code in the path you gave with a build directory and a fancy build script.\n"