**背景**：当两个服务器上部署两套互为主从的mysql高可用架构时，通过keepalived进行高可用管理，便会涉及两个VIP漂移的问题，以下为配置两套护互为主从的高可用mysql的keepalived配置  

```text

	! Configuration File for keepalived

	global_defs {
 	  router_id MYSQL_MM
	}

	vrrp_script chk_mysqld3307 {
 	   script "/usr/lib64/nagios/plugins/check_mysql -unagios  -p **** -H 192.168.1.31 -P3307"    #检测脚本,用来检测3307端口是否存活    192.168.1.32 为本机IP，从要修改成自己的IP
	   interval 1       # 间隔1秒检测一次
  	   weight -10     # 脚本结果导致的优先级变更，检测失败（脚本返回非0）则优先级 -10 
  	   fall 2           # 检测连续2次失败才算确定是真失败。会用weight减少优先级 
  	   rise 1         # 检测1次成功就算成功。但不修改优先级-->
	}           # 3307实例检测模块

	vrrp_script chk_mysqld3309 {
	    script "/usr/lib64/nagios/plugins/check_mysql -unagios  -p **** -H 192.168.1.32 -P3309"   #检测脚本   192.168.1.32 为本机IP，从要修改成自己的IP
	    interval 1
 	    weight -10    
  	    fall 2
  	    rise 1
	}           # 3309实例检测模块

		vrrp_instance VI_1 {
	    state MASTER      # keepalived 主标识  从修改为BACKUP
	    interface em2     # 网卡接口
	    virtual_router_id 98   # 主从ID一致  这个ID在相同网段不能重复！！！ 检测命令：tcpdump -nn -i any net 224.0.0.0/8 | grep 'vrid 100'     
	    priority 100     # 权重值  从要比主低 并且 主priority-从priority < weight 
	    advert_int 1
	    authentication {
        auth_type PASS
        auth_pass 1234
    }
	    virtual_ipaddress {
	        192.168.6.12    # vip
	    }
	    track_script {
	        chk_mysqld3307   #调用3307端口检测模块
	    }
	}

	vrrp_instance VI_2 {
	    state MASTER	  # keepalived 主标识 从修改为BACKUP
	    interface em2     # 网卡接口
	    virtual_router_id 99   # 同一网段内不能重复！！！主从一致
	    priority 100	  # 权重值，从要比主低 并且 主 priority  -  从priority < weight （100-95 < 10）
	    advert_int 1
	    authentication {
	        auth_type PASS  
	        auth_pass 4321
	    }
	    virtual_ipaddress {
	        192.168.6.13  # vip
	    }
	    track_script {
	        chk_mysqld3309  #调用3309端口检测模块
	    }
	}
```