# Demonstration

```
/proc/sys/vm/overcommit_memory
       This file contains the kernel virtual memory accounting mode.
       Values are:

              0: heuristic overcommit (this is the default)
              1: always overcommit, never check
              2: always check, never overcommit

       In mode 0, calls of mmap(2) with MAP_NORESERVE are not
       checked, and the default check is very weak, leading to the
       risk of getting a process "OOM-killed".

       In mode 2 (available since Linux 2.6), the total virtual
       address space that can be allocated (CommitLimit in /proc/mem©\
       info) is calculated as

           CommitLimit = (total_RAM - total_huge_TLB) *
                         overcommit_ratio / 100 + total_swap
```

The simple answer is that setting overcommit to 1, will set the stage so that when a program calls something 
like malloc() to allocate a chunk of memory (man 3 malloc), it will always succeed 
regardless if the system knows it will not have all the memory that is being asked for.

The underlying concept to understand is the idea of virtual memory. Programs see a virtual address space that may, or may not, 
be mapped to actual physical memory. By disabling overcommit checking, 
you tell the OS to just assume that there is always enough physical memory to backup the virtual space.

Example  
To highlight why this can sometimes matter, take a look at the [Redis guidances](https://redis.io/docs/getting-started/faq/#background-saving-fails-with-a-fork-error-on-linux)
on why vm.overcommit_memory should be set to 1 for it.

# Setting

0 is the default mode, where kernel heuristically determines the allocation by calculating the free memory compared to the allocation request being made.
And setting it to 1 enables the wizardry mode, where kernel always advertises that it has enough free memory for any allocation. 
Setting to 2, means that processes can only allocate up to a configurable amount (overcommit_ratio) of RAM 
and will start getting allocation failure or OOM messages when it goes beyond that amount.

Is it safe to do so, no. I haven't seen any proper use case where disabling memory overcommit actually helped, 
unless you are 100% certain of the workload and hardware capacity. In case you are interested, 
install kernel-docs package and go to /Documentation/sysctl/vm.txt to read more, or read it online.

If you set vm.overcommit_memory=2 then it will overcommit up to the percentage of physical RAM configured in vm.overcommit_ratio (default is 50%).

echo 0/1/2 > /proc/sys/vm/overcommit_memory 
This will not survive a reboot. For persistence, put this in /etc/sysctl.conf file:
vm.overcommit_memory=X
and run sysctl -p. No need to reboot.