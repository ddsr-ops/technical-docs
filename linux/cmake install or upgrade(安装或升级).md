If only install `cmake` via `yum`, it might not install the latest `cmake`. Therefore, installing `cmake` manually could be essential.

If you want to install the latest version of CMake (or some other version), you can always download the binary distribution from the [CMake download page](https://cmake.org/download/#previous).

Once downloaded, you can extract the package to somewhere you have access to on your machine, e.g.:

mkdir ~/cmake
tar xvzf ~/Downloads/cmake-3.18.2-Linux-x86_64.tar.gz -C ~/cmake
Finally, make sure you add the extracted bin directory to your PATH environment variable so you can run the cmake executable from the command line.