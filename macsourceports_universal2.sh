# game/app specific values
export APP_VERSION="1.1"
# devilutionX builds an .icns file, we will use that once it's been built
export ICONSDIR="Packaging/apple/"
export ICONSFILENAME="AppIcon"
export PRODUCT_NAME="devilutionX"
export EXECUTABLE_NAME="devilutionX"
export PKGINFO="APPLEDVLX"
export COPYRIGHT_TEXT="Diablo Copyright © 1995 Blizzard Entertainment. All rights reserved."

# constants
export BUILT_PRODUCTS_DIR="release"
export WRAPPER_NAME="${PRODUCT_NAME}.app"
export CONTENTS_FOLDER_PATH="${WRAPPER_NAME}/Contents"
export EXECUTABLE_FOLDER_PATH="${CONTENTS_FOLDER_PATH}/MacOS"
export UNLOCALIZED_RESOURCES_FOLDER_PATH="${CONTENTS_FOLDER_PATH}/Resources"
export ICONS="${ICONSFILENAME}.icns"
export BUNDLE_ID="com.macsourceports.${PRODUCT_NAME}"

# For parallel make on multicore boxes...
NCPU=`sysctl -n hw.ncpu`

rm -rf release

# create makefiles with cmake
rm -rf build-x86_64
mkdir build-x86_64
cd build-x86_64
sodium_INCLUDE_DIR=/usr/local/include 
sodium_LIBRARY_DEBUG=/usr/local/lib/libsodium.dylib
sodium_LIBRARY_RELEASE=/usr/local/lib/libsodium.dylib
/usr/local/bin/cmake -G "Unix Makefiles" -DCMAKE_C_FLAGS_RELEASE="-arch x86_64" -DCMAKE_BUILD_TYPE=Release -DCMAKE_OSX_DEPLOYMENT_TARGET=10.12 -DSDL2_DIR=/usr/local/opt/sdl2/lib/cmake/SDL2 -DSDL2_INCLUDE_DIRS=/usr/local/opt/sdl2/include/SDL2 -DSDL2_LIBRARIES=/usr/local/opt/sdl2/lib -DPKG_CONFIG_EXECUTABLE=/usr/local/bin/pkg-config -DDEVILUTIONX_SYSTEM_LIBFMT=OFF ..
# -Wno-dev

cd ..
rm -rf build-arm64
mkdir build-arm64
cd build-arm64
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_OSX_DEPLOYMENT_TARGET=10.12 ..
#-Wno-dev

# perform builds with make
cd ..
cd build-x86_64
make -j$NCPU
dylibbundler -od -b -x ./devilutionX.app/Contents/MacOS/devilutionX -d ./devilutionX.app/Contents/MacOS/libs-x86_64/ -p @executable_path/libs-x86_64/

cd ..
cd build-arm64
make -j$NCPU
dylibbundler -od -b -x ./devilutionX.app/Contents/MacOS/devilutionX -d ./devilutionX.app/Contents/MacOS/libs-arm64/ -p @executable_path/libs-arm64/

cd ..

# create the app bundle
"../MSPScripts/build_app_bundle.sh"

#lipo the executable
lipo build-x86_64/${EXECUTABLE_FOLDER_PATH}/${EXECUTABLE_NAME} build-arm64/${EXECUTABLE_FOLDER_PATH}/${EXECUTABLE_NAME} -output "${BUILT_PRODUCTS_DIR}/${EXECUTABLE_FOLDER_PATH}/${EXECUTABLE_NAME}" -create

#copy resources
mkdir "${BUILT_PRODUCTS_DIR}/${EXECUTABLE_FOLDER_PATH}/libs-x86_64"
cp -a "build-x86_64/${EXECUTABLE_FOLDER_PATH}/libs-x86_64/." "${BUILT_PRODUCTS_DIR}/${EXECUTABLE_FOLDER_PATH}/libs-x86_64"

mkdir "${BUILT_PRODUCTS_DIR}/${EXECUTABLE_FOLDER_PATH}/libs-arm64"
cp -a "build-arm64/${EXECUTABLE_FOLDER_PATH}/libs-arm64/." "${BUILT_PRODUCTS_DIR}/${EXECUTABLE_FOLDER_PATH}/libs-arm64"

cp -a "build-x86_64/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/." "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"

echo "bundle done."

#sign and notarize
"../MSPScripts/sign_and_notarize.sh" "$1"
