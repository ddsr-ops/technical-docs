# 问题
virtual box 6.1  
centos 6  
two ethes: one network type is host-only, the other one is nat.  
After rebooting system, two ethes hold the same ip which is a static ip on one of them.  

# 解决
chkconfig NetworkManager off
service NetworkManager stop
service network restart

**NOTE**: if system is centos 7, takes following operations.  
1. systemctl stop NetworkManager  
2. systemctl disable NetworkManager, makes sure NetworkManager auto-running service 
   is stopped by using systemctl is-enabled  NetworkManager  
3. Makes sure ifcfg-enp* configuration file has the property onboot of which value is 'yes'  
4. systemctl restart network.  