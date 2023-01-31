https://juejin.cn/post/6844903653644451853
https://segmentfault.com/a/1190000019932970
https://sisyphus-doc.github.io/#/guide


RemoteService.java

重试条件：遇到 RuntimeException  
重试次数：3  
重试策略：重试的时候等待 5S, 后面时间依次变为原来的 2 倍数。  
熔断机制：全部重试失败，则调用 recover() 方法。  

```
@Service
public class RemoteService {

    private static final Logger LOGGER = LoggerFactory.getLogger(RemoteService.class);

    /**
     * 调用方法
     */
    @Retryable(value = RuntimeException.class,
               maxAttempts = 3,
               backoff = @Backoff(delay = 5000L, multiplier = 2))
    public void call() {
        LOGGER.info("Call something...");
        throw new RuntimeException("RPC调用异常");
    }

    /**
     * recover 机制
     * @param e 异常
     */
    @Recover
    public void recover(RuntimeException e) {
        LOGGER.info("Start do recover things....");
        LOGGER.warn("We meet ex: ", e);
    }

}
```