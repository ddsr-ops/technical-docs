1.��firewalld����ǽ

systemctl start firewalld.service

(1) memcached �˿����á���������21.20.3.33����11211�˿�

firewall-cmd --permanent --add-rich-rule="rule family="ipv4" source address="21.20.3.33" port protocol="tcp" port="11211" accept"

(2) redis�˿����á���������21.20.3.33����6379�˿�

firewall-cmd --permanent --add-rich-rule="rule family="ipv4" source address="21.20.3.33" port protocol="tcp" port="6379" accept"

***

��firewalld����������һ��������ʹ��ܾ�192.168.10.0/24���ε������û����ʱ�����ssh����22�˿ڣ�

firewall-cmd --permanent --zone=public --add-rich-rule="rule family="ipv4" source address="192.168.10.0/24" service name="ssh" reject"

firewall-cmd --reload

������reload�����Ч

�鿴firewalld����

firewall-cmd --list-all

***

�ڿ�������ǽ֮��������Щ����ͻ���ʲ���������Ϊ�������ض˿�û�д򿪡�
�ڴ��Դ�80�˿�Ϊ��

firewall-cmd --add-port=80/tcp --permanent && firewall-cmd --relaod

����壺

--zone #������

--add-port=80/tcp #��Ӷ˿ڣ���ʽΪ���˿�/ͨѶЭ��

--permanent #������Ч��û�д˲���������ʧЧ