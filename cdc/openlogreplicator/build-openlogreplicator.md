# Env
[root@hadoop189 gch]# cat /etc/redhat-release 
CentOS Linux release 7.8.2003 (Core)

yum -y install autoconf automake diffutils file gcc gcc-c++ libaio libaio-devel libasan libnsl libtool make patch tar unzip wget zlib-devel git

Workspace: look for a directory, the following actions are performed in the dir

# Rapidjson

```shell
wget https://github.com/Tencent/rapidjson/archive/refs/tags/v1.1.0.tar.gz

tar xzvf v1.1.0.tar.gz ; 
# rm v1.1.0.tar.gz ; 
ln -s rapidjson-1.1.0 rapidjson ; 
```

# Oracle dependencies

```shell
wget https://download.oracle.com/otn_software/linux/instantclient/1918000/instantclient-basic-linux.x64-19.18.0.0.0dbru.zip ; 
unzip instantclient-basic-linux.x64-19.18.0.0.0dbru.zip ; 
# rm instantclient-basic-linux.x64-19.18.0.0.0dbru.zip ; 
wget https://download.oracle.com/otn_software/linux/instantclient/1918000/instantclient-sdk-linux.x64-19.18.0.0.0dbru.zip ; 
unzip instantclient-sdk-linux.x64-19.18.0.0.0dbru.zip ; 
# rm instantclient-sdk-linux.x64-19.18.0.0.0dbru.zip ; 
cd ./instantclient_19_18 ; 
ln -s libclntshcore.so.19.1 libclntshcore.so ; 
```

# Kafka dependencies

```shell
cd .. # back the workspace dir
wget https://github.com/edenhill/librdkafka/archive/refs/tags/v2.2.0.tar.gz ; 
#wget https://git.xfj0.cn/https://github.com/edenhill/librdkafka/archive/refs/tags/v2.2.0.tar.gz --no-check-certificate
tar xzvf v2.2.0.tar.gz ; 
# rm v2.2.0.tar.gz ; 
cd ./librdkafka-2.2.0 ; 
./configure --prefix=/hdp_data/librdkafka ; # some check failed, can ignore?
make ; 
make install ; 
```

# Protobuf dependencies

```shell
cd .. # back the workspace dir
wget https://git.xfj0.cn/https://github.com/protocolbuffers/protobuf/releases/download/v21.12/protobuf-cpp-3.21.12.tar.gz --no-check-certificate; 
tar xzvf protobuf-cpp-3.21.12.tar.gz ; 
# rm protobuf-cpp-3.21.12.tar.gz ; 
cd ./protobuf-3.21.12 ; 
./configure --prefix=/hdp_data/protobuf ; 
make ; 
make install ; 
```

# OpenLogReplicator

*gcc, gcc+, cmake should be upgraded, default versions in the Ceontos can support the building, refer to the last section of the doc for more details*

```shell
cd .. # back the workspace dir
# Compile the master branch
git clone https://git.xfj0.cn/https://github.com/bersler/OpenLogReplicator ; 
mv OpenLogReplicator OpenLogReplicator-master ; 

cd OpenLogReplicator-master
cd proto ; 
/hdp_data/protobuf/bin/protoc OraProtoBuf.proto --cpp_out=. ; 
mv OraProtoBuf.pb.cc ../src/common/OraProtoBuf.pb.cpp ; 
mv OraProtoBuf.pb.h ../src/common/OraProtoBuf.pb.h ; 
cd .. ; 

sudo yum install centos-release-scl
sudo yum install devtoolset-11
scl enable devtoolset-11 bash # Only available in the current session, gcc env changed temporarily to match the pre-check condition of building openlogrepliator, invalid if reconnect the ssh session
gcc --version

mkdir cmake-build-Release-x86_64 ; 
cd cmake-build-Release-x86_64 ; 
rm -rf * # empty the current building directory if have built before
# The -S and -B options were introduced in cmake version 3.13.
/hdp_data/gch/cmake-3.28.0-linux-x86_64/bin/cmake -DCMAKE_BUILD_TYPE=Release -DWITH_RAPIDJSON=/hdp_data/gch/openlogreplicator/rapidjson -DWITH_RDKAFKA=/hdp_data/librdkafka -DWITH_OCI=/hdp_data/gch/openlogreplicator/instantclient_19_18 -DWITH_PROTOBUF=/hdp_data/protobuf -S ../ -B ./  
/hdp_data/gch/cmake-3.28.0-linux-x86_64/bin/cmake --build ./ --target OpenLogReplicator -j ; 
mkdir -p /hdp_data/OpenLogReplicator ; 
mkdir -p /hdp_data/OpenLogReplicator/log ; 
mkdir -p /hdp_data/OpenLogReplicator/scripts ; 
mv ./OpenLogReplicator /hdp_data/OpenLogReplicator ; 
export LD_LIBRARY_PATH=/hdp_data/gch/openlogreplicator/instantclient_19_18:/hdp_data/librdkafka/lib; # run this using other users other root user
/hdp_data/OpenLogReplicator/OpenLogReplicator --version # run this using other users other root user
```


# gcc, g++, cmake

# gcc, g++

gcc stands for GNU Compiler Collection. It's a compiler system produced by the GNU Project that supports various programming languages. It is originally known for being a C compiler, hence the gcc name which stands for GNU C Compiler.

g++ is a part of the GNU Compiler Collection which supports C++ compilation.

These compilers turn your source code, written in a programming language like C or C++, into machine code that can then be executed directly by the system's CPU.

Here's a basic example of how you might use gcc or g++:

To compile a C program, you might run:

`gcc my_program.c -o my_program`

This will compile `my_program.c` into an executable named `my_program`.

Similarly, to compile a C++ program, you might run:


`g++ my_program.cpp -o my_program`
This will compile `my_program.cpp` into an executable named `my_program`.

## cmake

cmake is related to gcc and g++, but they serve different purposes.

cmake is a cross-platform build system generator. Projects specify their build process with platform-independent CMake lists file included in each directory of a source tree with the name CMakeLists.txt. cmake supports directory hierarchies and applications that depend on multiple libraries.

Basically, it can produce build files for a wide range of systems. These build files can then be processed by native build tools, such as make in Unix-based systems, or nmake in Windows, or others like ninja.

When using cmake with C or C++ code, it will typically generate makefiles that use gcc or g++ to compile the code.

Here's a basic example of how you might use cmake:

First, you would have a CMakeLists.txt file in your project root that specifies how to build your project.

Then, in a separate build directory, you would generate the makefiles and build the project like this:

```
mkdir build
cd build
cmake ..
make
```
In this example, cmake .. generates the makefiles based on the CMakeLists.txt in the parent directory, and make builds the project using those makefiles. The gcc or g++ compiler would be invoked by make, based on the instructions in the makefiles.
