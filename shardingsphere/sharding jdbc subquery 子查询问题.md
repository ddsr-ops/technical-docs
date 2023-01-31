version: 5.0.0 - alpha

I failed to invoke the following sql including a subquery stmt.

```sql
SELECT
    sub_ports.id AS id,
    sub_ports.name AS name,
    sub_ports.admin_state_up AS admin_state_up,
    sub_ports.status AS status,
    sub_ports.network_id AS network_id,
    sub_ports.tenant_id AS tenant_id,
    sub_ports.tenant_id AS project_id,
    sub_ports.device_id AS device_id,
    sub_ports.mac_address AS mac_address,
    sub_ports.device_owner AS device_owner,
    qos_port_policy_bindings.policy_id AS qos_policy_id,
    sub_ports.description AS description,
    sub_ports.created_at AS created_at,
    sub_ports.updated_at AS updated_at,
    ml2_port_bindings.vnic_type AS binding_vnic_type,
    ml2_port_bindings.vif_details AS binding_vif_details,
    ml2_port_bindings.profile AS binding_profile,
    sub_ports.instance_id AS instance_id,
    sub_ports.instance_type AS instance_type,
    sub_ports.ecs_flavor AS ecs_flavor
FROM
    (
        SELECT
            ports.id AS id,
            ports.name AS name,
            ports.admin_state_up AS admin_state_up,
            ports.status AS status,
            ports.network_id AS network_id,
            ports.tenant_id AS tenant_id,
            ports.device_id AS device_id,
            ports.mac_address AS mac_address,
            ports.device_owner AS device_owner,
            ports.description AS description,
            ports.created_at AS created_at,
            ports.updated_at AS updated_at,
            ports.instance_id AS instance_id,
            ports.instance_type AS instance_type,
            ports.ecs_flavor AS ecs_flavor
        FROM
            ports
        WHERE
			ports.tenant_id IN('xxxxxxxxxxxxxxxxxx')
        ORDER BY
            ports.id ASC LIMIT 2000
    ) AS sub_ports LEFT JOIN ml2_port_bindings
        ON ml2_port_bindings.port_id = sub_ports.id LEFT JOIN qos_port_policy_bindings
        ON qos_port_policy_bindings.port_id = sub_ports.id LEFT JOIN portsecuritybindings
        ON portsecuritybindings.port_id = sub_ports.id 
ORDER BY
    sub_ports.id ASC

```
***

I changed the sql, new sql is as follows:

```sql
SELECT
*
FROM
    (
        SELECT
            ports.id AS id,
            ports.name AS name,
            ports.admin_state_up AS admin_state_up,
            ports.status AS status,
            ports.network_id AS network_id,
            ports.tenant_id AS tenant_id,
            ports.device_id AS device_id,
            ports.mac_address AS mac_address,
            ports.device_owner AS device_owner,
            ports.description AS description,
            ports.created_at AS created_at,
            ports.updated_at AS updated_at,
            ports.instance_id AS instance_id,
            ports.instance_type AS instance_type,
            ports.ecs_flavor AS ecs_flavor
        FROM
            ports
        WHERE
			ports.tenant_id IN('xxxxxxxxxxxxxxxxxx')
        ORDER BY
            ports.id ASC LIMIT 2000
    ) AS sub_ports LEFT JOIN ml2_port_bindings
        ON ml2_port_bindings.port_id = sub_ports.id LEFT JOIN qos_port_policy_bindings
        ON qos_port_policy_bindings.port_id = sub_ports.id LEFT JOIN portsecuritybindings
        ON portsecuritybindings.port_id = sub_ports.id 
ORDER BY
    sub_ports.id ASC


```

[REF](https://github.com/apache/shardingsphere/issues/9024), according the issue, the problem was solved at version 5.0.0-beta