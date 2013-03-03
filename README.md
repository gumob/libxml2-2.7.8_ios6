#libxml2-2.7.8_ios6

##Build thread safe libxml2 for iOS 6
###1. Download libxml2-2.7.8
    curl -O ftp://xmlsoft.org/libxml2/libxml2-2.7.8.tar.gz
###2. Run build.sh on unzipped libxml2-2.7.8 directory
    tar zxfv libxml2-2.7.8.tar.gz
    cp build.sh libxml2-2.7.8/
    cd libxml2-2.7.8
    chmod +x build.sh
    ./build.sh

###3. Copy files and add Header Search Path to your project
    Xcode -> TARGETS -> Build Setting -> Header Search Path
    $(SRCROOT)/Submodules/libxml2-2.7.8_ios6

##Reference
1. [http://coin-c.tumblr.com/post/18063869172/thread-safe-xmllib2](http://coin-c.tumblr.com/post/18063869172/thread-safe-xmllib2, "http://coin-c.tumblr.com/post/18063869172/thread-safe-xmllib2")
2. [http://pastie.org/3429938](http://pastie.org/3429938, "http://pastie.org/3429938")
