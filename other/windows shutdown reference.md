# Syntax
shutdown [/i | /l | /s | /sg | /r | /g | /a | /p | /h | /e | /o] [/hybrid] [/fw] [/f] [/m \\computer][/t xxx][/d [p|u:]xx:yy [/c "comment"]]

# Parameters
```
Parameter	Description
/i	Displays the Remote Shutdown box. The /i option must be the first parameter following the command. If /i is specified, all other options are ignored.
/l	Logs off the current user immediately, with no time-out period. You cannot use /l with /m or /t.
/s	Shuts down the computer.
/sg	Shuts down the computer. On the next boot, if Automatic Restart Sign-On is enabled, the device automatically signs in and locks based on the last interactive user. After sign in, it restarts any registered applications.
/r	Restarts the computer after shutdown.
/g	Shuts down the computer. On the next restart, if Automatic Restart Sign-On is enabled, the device automatically signs in and locks based on the last interactive user. After sign in, it restarts any registered applications.
/a	Aborts a system shutdown. This can only be used during the time-out period. Combine with /fw to clear any pending boots to firmware.
/p	Turns off the local computer only (not a remote computer)¡ªwith no time-out period or warning. You can use /p only with /d or /f. If your computer doesn't support power-off functionality, it will shut down when you use /p, but the power to the computer will remain on.
/h	Puts the local computer into hibernation, if hibernation is enabled. The /f switch can be used with the /h switch.
/hybrid	Shuts down the device and prepares it for fast startup. This option must be used with the /s option.
/fw	Combining this option with a shutdown option causes the next restart to go to the firmware user interface.
/e	Enables you to document the reason for an unexpected shutdown of a computer in the Shutdown Event Tracker.
/o	Goes to the Advanced boot options menu and restarts the device. This option must be used with the /r option.
/f	Forces running applications to close without warning users. 
    Caution: Using the /f option might result in loss of unsaved data.
/m \\<computername>	Specifies the target computer. Can't be used with the /l option.
/t <xxx>	Sets the time-out period before shutdown to xxx seconds. The valid range is 0-315360000 (10 years), with a default of 30. If the timeout period is greater than 0, the /f parameter is implied.
/d [p \| u:]<xx>:<yy>	Lists the reason for the system restart or shutdown. The supported parameter values are:
                        P - Indicates that the restart or shutdown is planned.
                        U - Indicates that the reason is user-defined.
                        NOTE
                        If p or u aren't specified, the restart or shutdown is unplanned.

xx - Specifies the major reason number (a positive integer, less than 256).
yy Specifies the minor reason number (a positive integer, less than 65536).
/c <comment>	Enables you to comment in detail about the reason for the shutdown. You must first provide a reason by using the /d option and you must enclose your comments in quotation marks. You can use a maximum of 511 characters.
/?	Displays help at the command prompt, including a list of the major and minor reasons that are defined on your local computer.
```

**If /f or /t parameter is specified, system might be shutdown forcefully**


# Examples
To force apps to close and to restart the local computer after a one-minute delay, with the reason Application: Maintenance (Planned) and the comment "Reconfiguring myapp.exe", type:

shutdown /r /t 60 /c "Reconfiguring myapp.exe" /f /d p:4:1


To restart the remote computer myremoteserver with the same parameters as the previous example, type:

shutdown /r /m \\myremoteserver /t 60 /c "Reconfiguring myapp.exe" /f /d p:4:1