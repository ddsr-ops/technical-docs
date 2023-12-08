How to build OpenLogReplicator, refer to 'build-openlogreplicator.md'

# Prerequisites

It is not permitted to use root user to run the OpenLogReplicator, so creating another use is essential.

```shell
groupadd olr
useradd olr -g olr
```

As for how to configure and install OpenLogReplicator,  go to [installation](https://github.com/bersler/OpenLogReplicator/blob/master/documentation/installation/installation.adoc) for more details.


[Non support RAC](https://github.com/bersler/OpenLogReplicator/issues/35)
[Non support ASM instance](https://github.com/bersler/OpenLogReplicator/issues/34)

Because of the above aspects, So give up testing Replicator temporarily.
