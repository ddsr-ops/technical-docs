https://juejin.cn/post/6844903653644451853
https://segmentfault.com/a/1190000019932970
https://sisyphus-doc.github.io/#/guide


RemoteService.java

�������������� RuntimeException  
���Դ�����3  
���Բ��ԣ����Ե�ʱ��ȴ� 5S, ����ʱ�����α�Ϊԭ���� 2 ������  
�۶ϻ��ƣ�ȫ������ʧ�ܣ������ recover() ������  

```
@Service
public class RemoteService {

    private static final Logger LOGGER = LoggerFactory.getLogger(RemoteService.class);

    /**
     * ���÷���
     */
    @Retryable(value = RuntimeException.class,
               maxAttempts = 3,
               backoff = @Backoff(delay = 5000L, multiplier = 2))
    public void call() {
        LOGGER.info("Call something...");
        throw new RuntimeException("RPC�����쳣");
    }

    /**
     * recover ����
     * @param e �쳣
     */
    @Recover
    public void recover(RuntimeException e) {
        LOGGER.info("Start do recover things....");
        LOGGER.warn("We meet ex: ", e);
    }

}
```