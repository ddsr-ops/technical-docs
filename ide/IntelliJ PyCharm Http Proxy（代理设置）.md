Specify settings of an HTTP or SOCKS proxy server if you want the traffic to go through it when IntelliJ IDEA accesses 
the Internet. The HTTP proxy works for both HTTP and HTTPS connections.

<u>Note: These settings affect the connections that IntelliJ IDEA establishes to download plugins, check license 
validity, synchronize IDE settings between instances, and perform other tasks for the IDE itself.</u>

In my environment, I have a proxy in my local PC. If IDEs use the system proxy, set this via `System Settings -> 
Http Proxy -> Auto detect Proxy Settings`. However, popup a window to prompt you type your proxy authentication
username and password every time you start the IDE. This is a Bug never fixed so far.

Hence, when downloading plugins like `Codeium Ai assistant`, enable the proxy settings to use system http proxy 
temporarily. Do not forget to disable the proxy settings when you finish using it. In addition, some plugins would
download other dependencies simultaneously. The download action should be finished before disabling the proxy. 
