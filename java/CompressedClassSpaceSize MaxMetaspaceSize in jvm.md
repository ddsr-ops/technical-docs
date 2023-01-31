Metaspace is the memory area for storing class metadata - internal JVM structures created while parsing .class files.

Class metadata includes:

* Internal representation of Java classes
* Methods with their bytecode
* Field descriptors
* Constant pools
* Symbols
* Annotations
* etc.
-XX:MaxMetaspaceSize is unlimited by default.

When -XX:+UseCompressedClassPointers option is ON (default for heaps < 32G), classes are moved from Metaspace to the separate area called Compressed Class Space. This is to allow addressing VM class structures with 32-bit values instead of 64-bit.

So, Compressed Class Space contains internal representation of Java classes, while Metaspace holds all the rest metadata: methods, constant pools, annotations, etc.

The size of Compressed Class Space is limited by -XX:CompressedClassSpaceSize, which is 1G by default. The maximum possible value of -XX:CompressedClassSpaceSize is 3G.

Non-class Metaspace and Compressed Class Space are two disjoint areas. MaxMetaspaceSize limits the committed size of both areas:

committed(Non-class Metaspace) + committed(Compressed Class Space) <= MaxMetaspaceSize
If MaxMetaspaceSize is set smaller than CompressedClassSpaceSize, the latter is automatically decreased to

CompressedClassSpaceSize = MaxMetaspaceSize - 2*InitialBootClassLoaderMetaspaceSize






Compressed Class Space.

The default limit is exactly 1GB, it can be decreased with -XX:CompressedClassSpaceSize=N.

The "Class" area in Native Memory Tracking output includes both Metaspace and Compressed Class Space, that's why you see more than 1GB reserved. However, the reserved memory is just the amount of virtual address space - it does not take physical memory pages.