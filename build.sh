#!/bin/bash
# build.sh
# 
# libxml2-2.7.8_ios6
# 
# Build thread safe libxml2 for iOS 6
# 
# 1) Download libxml2-2.7.8
#    ftp://xmlsoft.org/libxml2/libxml2-2.7.8.tar.gz
# 2) Run build.sh on unzipped libxml2-2.7.8 directory
# 3) Copy libxml2.a and header files to your project directory
# 4) Add Header Search Path
#    Example: $(SRCROOT)/Submodules/libxml2-2.7.8_ios6
# 
# Referenced
# http://coin-c.tumblr.com/post/18063869172/thread-safe-xmllib2
# http://pastie.org/3429938
#

GLOBAL_OUTDIR="`pwd`/build"
LOCAL_OUTDIR="`pwd`/build"

IOS_BASE_SDK="6.1"
IOS_DEPLOY_TGT="6.0"

CONFIGURE_OPTIONS="--without-zlib --without-iconv --with-threads"

setenv_all()
{
	# Add internal libs
    export CFLAGS="$CFLAGS -I$GLOBAL_OUTDIR/include -L$GLOBAL_OUTDIR/lib"
    
    export CXX="$DEVROOT/usr/bin/llvm-g++"
    export CC="$DEVROOT/usr/bin/llvm-gcc"
 
    export LD=$DEVROOT/usr/bin/ld
    export AR=$DEVROOT/usr/bin/ar
    export AS=$DEVROOT/usr/bin/as
    export NM=$DEVROOT/usr/bin/nm
    
    export RANLIB=$DEVROOT/usr/bin/ranlib
    export LDFLAGS="-L$SDKROOT/usr/lib/"
    
    export CPPFLAGS=$CFLAGS
    export CXXFLAGS=$CFLAGS
}

setenv_arm7()
{
    unset DEVROOT SDKROOT CFLAGS CC LD CPP CXX AR AS NM CXXCPP RANLIB LDFLAGS CPPFLAGS CXXFLAGS
    
    export DEVROOT=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer
    export SDKROOT=$DEVROOT/SDKs/iPhoneOS$IOS_BASE_SDK.sdk
    
    export CFLAGS="-arch armv7 -pipe -no-cpp-precomp -isysroot $SDKROOT -miphoneos-version-min=$IOS_DEPLOY_TGT -I$SDKROOT/usr/include/"
    
    setenv_all
}
 
setenv_arm7s()
{
    unset DEVROOT SDKROOT CFLAGS CC LD CPP CXX AR AS NM CXXCPP RANLIB LDFLAGS CPPFLAGS CXXFLAGS
    
    export DEVROOT=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer
    export SDKROOT=$DEVROOT/SDKs/iPhoneOS$IOS_BASE_SDK.sdk
    
    export CFLAGS="-arch armv7s -pipe -no-cpp-precomp -isysroot $SDKROOT -miphoneos-version-min=$IOS_DEPLOY_TGT -I$SDKROOT/usr/include/"
    
    setenv_all
}
 
setenv_i386()
{
    unset DEVROOT SDKROOT CFLAGS CC LD CPP CXX AR AS NM CXXCPP RANLIB LDFLAGS CPPFLAGS CXXFLAGS
    
    export DEVROOT=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer
    export SDKROOT=$DEVROOT/SDKs/iPhoneSimulator$IOS_BASE_SDK.sdk
    
    export CFLAGS="-arch i386 -pipe -no-cpp-precomp -isysroot $SDKROOT -miphoneos-version-min=$IOS_DEPLOY_TGT"
    
    setenv_all
}

create_outdir_lipo()
{
	for lib_i386 in `find $LOCAL_OUTDIR/i386 -name "lib*\.a"`; do
		lib_arm7=`echo $lib_i386 | sed "s/i386/arm7/g"`
		lib_arm7s=`echo $lib_i386 | sed "s/i386/arm7s/g"`
		lib=`echo $lib_i386 | sed "s/i386\///g"`
		xcrun -sdk iphoneos lipo -arch armv7s $lib_arm7s -arch armv7 $lib_arm7 -arch i386 $lib_i386 -create -output $lib
	done
}


rm -rf $LOCAL_OUTDIR
mkdir -p $LOCAL_OUTDIR/arm7 $LOCAL_OUTDIR/i386 $LOCAL_OUTDIR/arm7s


make clean 2> /dev/null
make distclean 2> /dev/null
setenv_arm7
./configure --host=arm-apple-darwin7 --enable-shared=no --enable-thread-safe ${CONFIGURE_OPTIONS} --prefix $LOCAL_OUTDIR
make; make install
mv build/lib/libxml2.a libxml2-armv7.a


make clean 2> /dev/null
make distclean 2> /dev/null
setenv_arm7s
./configure --host=arm-apple-darwin7s --enable-shared=no --enable-thread-safe ${CONFIGURE_OPTIONS} --prefix $LOCAL_OUTDIR
make; make install
mv build/lib/libxml2.a libxml2-armv7s.a


make clean 2> /dev/null
make distclean 2> /dev/null
setenv_i386
./configure --enable-shared=no ${CONFIGURE_OPTIONS} --enable-thread-safe --prefix $LOCAL_OUTDIR
make; make install
mv build/lib/libxml2.a libxml2-i386.a


xcrun -sdk iphoneos lipo -arch armv7 libxml2-armv7.a -arch armv7s libxml2-armv7s.a -arch i386 libxml2-i386.a -create -output build/libxml2.a







