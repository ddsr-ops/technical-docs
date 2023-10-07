### innodb_flushing_avg_loops

* Variable Scope: Global
* Dynamic Variable: Yes
* Type: integer , Default Value: 30, Minimum Value: 1, Maximum: 1000

Number of iterations for which InnoDB keeps the previously calculated snapshot of the flushing
state, controlling how quickly adaptive flushing responds to changing workloads. Increasing the
value makes the rate of flush operations change smoothly and gradually as the workload changes.
Decreasing the value makes adaptive flushing adjust quickly to workload changes, which can cause
spikes in flushing activity if the workload increases and decreases suddenly.