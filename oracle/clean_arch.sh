# +-------------------------------------------------------+  
# +    Clean archived log as specified time               |  
# +    Author : Robinson                                  |  
# +    Blog   : http://blog.csdn.net/robinson_0612        |  
# +    Usage  :                                           |   
# +         clean_arch.sh $ORACLE_SID                     |  
# +-------------------------------------------------------+  
#  
#!/bin/bash   
# --------------------  
# Define variable  
# --------------------

if [ -f ~/.bash_profile ]; then
. ~/.bash_profile
fi


# after clean, check flash recovery area by running sql SELECT * FROM v$flash_recovery_area_usage
ORACLE_SID=tft;export ORACLE_SID
$ORACLE_HOME/bin/rman log=/tmp/rman.log <<EOF
connect target /
run{
crosscheck archivelog all;
delete noprompt expired archivelog all;
delete noprompt archivelog all completed before 'sysdate - 1/24';
}
exit;
EOF
exit