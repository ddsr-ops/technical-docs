```
CREATE unique INDEX pk_promotion_entity_id ON T_PROMOTION_ENTITY (id) GLOBAL PARTITION BY HASH (id) partitions 16;

alter table T_PROMOTION_ENTITY add constraint pk_promotion_entity_id primary key(id) using index pk_promotion_entity_id;

```