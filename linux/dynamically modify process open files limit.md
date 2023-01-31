Remember to modify `/etc/security/limits.conf` file, to prevent invalid after system restarting

# Query

ulimit -a|grep open

cat /proc/32546/limits |grep open

prlimit --pid 32546

Note: 32456 is a process number


# Dynamically  Modify

prlimit --pid 32546 --nofile=65535


If you modified `/etc/security/limits.conf` file, it works after you re-login.