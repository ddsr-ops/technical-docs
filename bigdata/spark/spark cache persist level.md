import org.apache.spark.storage.StorageLevel

// 数据持久缓存到内存中
//data.cache()
data.persist()

// 设置缓存级别
data.persist(StorageLevel.DISK_ONLY)
   
// 清除缓存
data.unpersist
//data.unpersist(blocking=true)


| 级别 | 使用空间	|CPU时间|是否在内存中|	是否在磁盘上|	备注 |
| :-----: | :----: | :----: |:-----: | :----: | :----: |
|MEMORY_ONLY|高|低|是|否|　
|MEMORY_ONLY_2|高|低|是|否|数据存2份
|MEMORY_ONLY_SER|低|高|是|否|数据序列化
|MEMORY_ONLY_SER_2|低|高|是|否|数据序列化，数据存2份
|MEMORY_AND_DISK|高|中等|部分|部分|如果数据在内存中放不下，则溢写到磁盘
|MEMORY_AND_DISK_2|高|中等|部分|部分|数据存2份
|MEMORY_AND_DISK_SER|低|高|部分|部分|　
|MEMORY_AND_DISK_SER_2|低|高|部分|部分|数据存2份
|DISK_ONLY|低|高|否|是|　
|DISK_ONLY_2|低|高|否|是|数据存2份
|NONE|　|　|　|　|　
|OFF_HEAP|　|　|　|　|　	　	　	　	　
