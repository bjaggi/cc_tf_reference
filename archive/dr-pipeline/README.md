# Confluent Cloud Failover and Failback Process
This repository contains a set of scripts to automate the failover and failback process in Confluent Cloud. The failover process involves detecting a regional outage, checking the health of the Disaster Recovery (DR) cluster, failing over mirror topics, changing the DR Schema Registry mode, updating applications and connectors, starting clients in the DR region, performing business tests, and validating the failover. The failback process involves deleting topics on the primary cluster, establishing a cluster link in the reverse direction, wiping the original Schema Registry cluster, creating a schema exporter on the DR environment, waiting for synchronization, stopping producers and consumers, promoting mirror topics, switching the original Schema Registry to READWRITE, updating applications and connectors, starting clients in the primary region, and performing validation activities.

## Failover Steps
1. Detect regional outage via metrics going to zero in the primary region: Monitor metrics related to the primary region and detect any significant decrease or drop to zero, indicating a regional outage.

2. Check DR cluster health: Verify the health and availability of the DR cluster to ensure it is ready for failover.

3. Failover mirror topics on DR cluster: Use the provided script (schema_exporter_creation.py) to create the schema exporter on the DR cluster, enabling mirroring of topics from the primary region to the DR region.

4. Change the DR Schema Registry from IMPORT mode to READWRITE mode: Utilize the provided script (schema_registry_mode_change.py) to change the mode of the DR Schema Registry from IMPORT to READWRITE, allowing read and write operations on the DR cluster.

5. Update applications and connectors properties to point to the new DR clusters: Update the necessary properties in applications and connectors to direct them to the DR cluster for data ingestion and consumption.

6. Start clients pointed to DR region: Initiate the necessary clients, consumers, producers, or other components to connect to the DR region and consume or produce data.

7. Business Tests: Perform application-specific tests and validations to ensure seamless integration and functionality with the DR clusters.

8. Start fully managed connectors on DR if they exist: If there are any fully managed connectors in the primary region, start them in the DR region to continue data integration and pipeline operations.

9. Run KSQL queries on DR if they exist: If KSQL queries are utilized, execute them on the DR region to process and analyze data.

10. Delete Cluster Link: Use the provided script (cluster_link_deletion.py) to delete the cluster link between the primary and DR clusters.

11. Delete Schema exporter: Utilize the provided script (schema_exporter_deletion.py) to delete the schema exporter in the DR cluster.

12. Validation: Perform validation activities to ensure the success of the failover process. This may include recovering any lagged data if necessary and checking data integrity.

## Failback Steps

1. Delete topics on the Primary cluster: Use the provided script or API calls to delete topics on the primary cluster.

2. Establish a cluster link in the reverse direction with consumer offset sync and auto-mirror topic creation: Set up a cluster link between the DR and primary clusters, ensuring consumer offset synchronization and enabling auto-mirror topic creation.

3. Wipe the original Schema Registry cluster and set it to IMPORT mode: Delete all data in the original Schema Registry cluster and configure it to import mode, ready for data replication.

4. Create Schema exporter on the DR environment: Use the provided script (schema_exporter_creation.py) to create the schema exporter on the DR environment, enabling mirroring of topics from the DR region to the primary region.

5. Wait until Primary Kafka cluster and Schema Registry are synced: Allowthe primary Kafka cluster and Schema Registry to synchronize and ensure they are in sync before proceeding.

6. Stop producers and consumers: Stop any active producers and consumers in the DR region to prepare for failback.

7. Check mirror lag is 0: Monitor the mirror lag between the DR and primary clusters and ensure it is at 0, indicating that the replication is up to date.

8. Promote mirror topics: Promote the mirror topics from the DR cluster to the primary cluster, making them primary topics.

9. Switch the original Schema Registry to READWRITE: Utilize the provided script (schema_registry_mode_change.py) to change the mode of the original Schema Registry to READWRITE.

10. Update applications and connectors properties to point to the primary clusters: Update the necessary properties in applications and connectors to direct them to the primary clusters for data ingestion and consumption.

11. Start clients in primary region: Initiate the necessary clients, consumers, producers, or other components to connect to the primary region and consume or produce data.

12. Start fully managed connectors on Primary if they exist: If there are any fully managed connectors in the DR region, start them in the primary region to resume data integration and pipeline operations.

13. Run KSQL queries on Primary if they exist: If KSQL queries are utilized, execute them on the primary region to process and analyze data.

14. Validation: Perform validation activities to ensure the success of the failback process. This may include verifying data integrity, conducting business tests, and confirming integration with the primary clusters.

15. Check data integrity: Verify the integrity and consistency of the data in the primary region to ensure a seamless failback and data replication.

## Script References
- schema_exporter_creation.py: Script to create the schema exporter and mirror topics from the primary region to the DR region.

- schema_registry_mode_change.py: Script to change the mode of the Schema Registry to READWRITE or IMPORT.

- cluster_link_deletion.py: Script to delete the cluster link between the primary and DR clusters.

- schema_exporter_deletion.py: Script to delete the schema exporter in the DR cluster.

Please refer to the specific script documentation and usage instructions for executing the corresponding steps mentioned above.

## Disclaimer
The provided scripts and failover/failback processes are intended as a starting point and should be customized and thoroughly tested based on your specific Confluent Cloud setup and requirements. Always refer to the official Confluent Cloud documentation for best practices and up-to-date instructions.
