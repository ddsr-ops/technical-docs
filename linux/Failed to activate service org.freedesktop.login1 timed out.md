# Symptoms

The following text from `/var/log/messages`

```text
Oct 30 15:57:34 datanode1 cm: 3168-elasticsearch-ES_NODE: removed process group
Oct 30 15:57:42 datanode1 systemd-logind: Failed to start session scope session-38128.scope: Connection timed out
Oct 30 15:57:42 datanode1 dbus[1559]: [system] Failed to activate service 'org.freedesktop.systemd1': timed out
Oct 30 15:58:26 datanode1 dbus[1559]: [system] Failed to activate service 'org.freedesktop.systemd1': timed out
Oct 30 15:58:26 datanode1 systemd-logind: Failed to start session scope session-38129.scope: Failed to activate service 'org.freedesktop.systemd1': timed out
```

# Solution

reboot -f