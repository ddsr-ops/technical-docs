When reading iceberg source code, some jars were not found.
Such as "org.apache.iceberg.relocated.XX" jars, can not be resolved.

Solution: 
Go to file build.gradle, run the section `shadowJar`