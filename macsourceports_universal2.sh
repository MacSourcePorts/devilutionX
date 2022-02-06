# game/app specific values
export APP_VERSION="1.2.0"
# devilutionX builds an .icns file, we will use that once it's been built
export ICONSDIR="Packaging/apple/"
export ICONSFILENAME="AppIcon"
export PRODUCT_NAME="devilutionX"
export EXECUTABLE_NAME="devilutionX"
export PKGINFO="APPLEDVLX"
export COPYRIGHT_TEXT="Diablo Copyright © 1995 Blizzard Entertainment. All rights reserved."

#constants
source ../MSPScripts/constants.sh

rm -rf ${BUILT_PRODUCTS_DIR}

# create makefiles with cmake
rm -rf ${X86_64_BUILD_FOLDER}
mkdir ${X86_64_BUILD_FOLDER}
cd ${X86_64_BUILD_FOLDER}
sodium_INCLUDE_DIR=/usr/local/include
sodium_LIBRARY_DEBUG=/usr/local/lib/libsodium.dylib
sodium_LIBRARY_RELEASE=/usr/local/lib/libsodium.dylib
/usr/local/bin/cmake -G "Unix Makefiles" -DVERSION_NUM=${APP_VERSION} -DCMAKE_C_FLAGS_RELEASE="-arch x86_64" -DCMAKE_BUILD_TYPE=Release -DCMAKE_OSX_DEPLOYMENT_TARGET=10.12 -DSDL2_DIR=/usr/local/opt/sdl2/lib/cmake/SDL2 -DSDL2_INCLUDE_DIRS=/usr/local/opt/sdl2/include/SDL2 -DSDL2_LIBRARIES=/usr/local/opt/sdl2/lib -DPKG_CONFIG_EXECUTABLE=/usr/local/bin/pkg-config -DDEVILUTIONX_SYSTEM_LIBFMT=OFF ..
# -Wno-dev

cd ..
rm -rf ${ARM64_BUILD_FOLDER}
mkdir ${ARM64_BUILD_FOLDER}
cd ${ARM64_BUILD_FOLDER}
cmake -G "Unix Makefiles" -DVERSION_NUM=${APP_VERSION} -DCMAKE_BUILD_TYPE=Release -DCMAKE_OSX_DEPLOYMENT_TARGET=10.12 ..
#-Wno-dev

# perform builds with make
cd ..
cd ${X86_64_BUILD_FOLDER}
make -j$NCPU

cd ..
cd ${ARM64_BUILD_FOLDER}
make -j$NCPU

cd ..

# create the app bundle
"../MSPScripts/build_app_bundle.sh"

#sign and notarize
"../MSPScripts/sign_and_notarize.sh" "$1"
