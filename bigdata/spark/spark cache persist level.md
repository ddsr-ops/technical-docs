import org.apache.spark.storage.StorageLevel

// ���ݳ־û��浽�ڴ���
//data.cache()
data.persist()

// ���û��漶��
data.persist(StorageLevel.DISK_ONLY)
   
// �������
data.unpersist
//data.unpersist(blocking=true)


| ���� | ʹ�ÿռ�	|CPUʱ��|�Ƿ����ڴ���|	�Ƿ��ڴ�����|	��ע |
| :-----: | :----: | :----: |:-----: | :----: | :----: |
|MEMORY_ONLY|��|��|��|��|��
|MEMORY_ONLY_2|��|��|��|��|���ݴ�2��
|MEMORY_ONLY_SER|��|��|��|��|�������л�
|MEMORY_ONLY_SER_2|��|��|��|��|�������л������ݴ�2��
|MEMORY_AND_DISK|��|�е�|����|����|����������ڴ��зŲ��£�����д������
|MEMORY_AND_DISK_2|��|�е�|����|����|���ݴ�2��
|MEMORY_AND_DISK_SER|��|��|����|����|��
|MEMORY_AND_DISK_SER_2|��|��|����|����|���ݴ�2��
|DISK_ONLY|��|��|��|��|��
|DISK_ONLY_2|��|��|��|��|���ݴ�2��
|NONE|��|��|��|��|��
|OFF_HEAP|��|��|��|��|��	��	��	��	��
