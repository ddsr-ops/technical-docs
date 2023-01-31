We configure kafka in a docker, in order to be connected from outer machine.

This is my docker compose file in my virtual machine.

```
version: '2'
services:
  zookeeper:
    image: wurstmeister/zookeeper
    ports:
      - "2181:2181"
  kafka:
    image: wurstmeister/kafka
    ports:
      - "9092:9092"
    environment:
      HOST_NAME: docker
      DOCKER_API_VERSION: 1.26
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://docker:9092
      KAFKA_LISTENERS: PLAINTEXT://0.0.0.0:9092
      KAFKA_CREATE_TOPICS: "test:1:1"
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
    extra_hosts:
      docker: 192.168.20.140
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
```

1. docker is virtual machine name
2. `192.168.20.140` is ip address of virtual machine
3. need to add `192.168.20.140 docker` in both `/etc/hosts` in the virtual machine and `hosts` file of windows
4. 



****************************************************************************************************
[Reference](https://www.cnblogs.com/kendoziyu/p/15134041.html)

# Docker compose file
KAFKA_ADVERTISED_HOST_NAME 不建议使用了，因为它对应 server.properties 中的 advertised.host.name，
而这个属性已经是 DEPRECATED

参考自 http://kafka.apache.org/0100/documentation.html#brokerconfigs

作为替代可以使用 KAFKA_ADVERTISED_LISTENERS，该环境变量对应 server.properties 中的 advertised.listeners.

相信你们和我有一样的疑惑， 戳-> kafka listeners 和 advertised.listeners 的区别及应用

我的宿主机的IP地址是 10.24.99.195，我的 docker-compose.yml 文件内容如下：

```
version: '3.8'
services:
  zookeeper:
    image: wurstmeister/zookeeper
    ports:
      - "2181:2181"
    restart: always
  kafka1:
    image: wurstmeister/kafka
    depends_on: [ zookeeper ]
    container_name: kafka1
    ports:
      - "9091:9091"
    environment:
      HOSTNAME: kafka1
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka1:9091
      KAFKA_LISTENERS: PLAINTEXT://0.0.0.0:9091
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
    extra_hosts:
      kafka1: 10.24.99.195
  kafka2:
    image: wurstmeister/kafka
    depends_on: [ zookeeper ]
    container_name: kafka2
    ports:
      - "9092:9092"
    environment:
      HOSTNAME: kafka2
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka2:9092
      KAFKA_LISTENERS: PLAINTEXT://0.0.0.0:9092
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
    extra_hosts:
      kafka2: 10.24.99.195
  kafka3:
    image: wurstmeister/kafka
    depends_on: [ zookeeper ]
    container_name: kafka3
    ports:
      - "9093:9093"
    environment:
      HOSTNAME: kafka3
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka3:9093
      KAFKA_LISTENERS: PLAINTEXT://0.0.0.0:9093
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
    extra_hosts:
      kafka3: 10.24.99.195
```
环境变量 KAFKA_LISTENERS 的 INSIDE 和 OUTSIDE 的端口必须不同。

接着，cd进入docker-compose.yml所在的工作目录，运行命令 docker-compose up -d，此时默认就是使用该文件。

container_name 属性：使用 docker ps 命令看到 NAMES 一列，将以你的命名相同。
HOSTNAME 和 extra_hosts 的组合使用：在容器的 /etc/hosts 中增加一条记录
例如，docker exec -it kafka1 cat /etc/hosts 命令查看容器 kafka1 的 /etc/hosts 文件，多出一条映射：

10.24.99.195    kafka1
参考自 自定义Docker容器的 hostname

# 容器内验证
进入容器的方法，就不啰嗦了，不了解的可以百度。（docker ps 和 docker exec -it CONTAINER_ID bash）

1、创建一个主题 mytopic：

`kafka-topics.sh --create --topic mytopic --partitions 2 --zookeeper kafka_zookeeper_1:2181 --replication-factor 2`

2、打开一个窗口，进入容器作生产者：

`kafka-console-producer.sh --topic=mytopic --broker-list kafka1:9091,kafka2:9092,kafka3:`9093

3、再打开一个窗口，进入容器作消费者：

`kafka-console-consumer.sh --bootstrap-server kafka1:9091,kafka2:9092,kafka3:9093 --from-beginning --topic mytopic`

在kafka集群内部，我们使用的集群字符串都是 kafka1:9091,kafka2:9092,kafka3:9093


# 代码中验证
3.1 消费端：

```java
ReceiverService.java:

import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class ReceiverService {

    @KafkaListener(topics = {"news"}, groupId = "agent")
    public void listen(ConsumerRecord<?, ?> record) {
        Optional<?> message = Optional.ofNullable(record.value());
        if (message.isPresent()) {
            System.out.println("receiver record = " + record);
            System.out.println("receiver message = " + message.get());
        }
    }
}
```

application.properties:

spring.kafka.bootstrap-servers=kafka2:9090,kafka1:9091,kafka3:9093

3.2 生产端：
```java
SendController.java

import com.alibaba.fastjson.JSON;
import com.example.kafka.producer.dto.Message;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Date;

@Controller
@RequestMapping
public class SendController {

    @Autowired
    private KafkaTemplate<String, String> kafkaTemplate;

    @RequestMapping("/send")
    @ResponseBody
    public String send(@RequestParam String msg) {
        Message message = new Message();

        message.setId(System.currentTimeMillis());
        message.setMessage(msg);
        message.setSendAt(new Date());

        kafkaTemplate.send("news", JSON.toJSONString(message));
        return JSON.toJSONString(message);
    }
}
```

application.properties:

spring.kafka.bootstrap-servers=kafka2:9090,kafka1:9091,kafka3:9093

另外，pom.xml 需要多一个 fastjson 的依赖：
```
<dependency>
  <groupId>com.alibaba</groupId>
  <artifactId>fastjson</artifactId>
  <version>1.2.76</version>
</dependency>
```
3.3 测试中的问题

先启动生产端，然后访问 http://localhost:8080/send?msg=hello，你会遇到这个异常：

org.apache.kafka.common.config.ConfigException: No resolvable bootstrap urls given in bootstrap.servers
在你的宿主机上修改 hosts 文件，在末尾追加
```
10.24.99.195 kafka1
10.24.99.195 kafka2
10.24.99.195 kafka3
```
10.24.99.195 是我当前的主机IP，你需要改成你的主机IP