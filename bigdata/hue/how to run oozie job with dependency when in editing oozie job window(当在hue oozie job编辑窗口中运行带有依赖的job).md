How to run oozie job with dependency when in editing oozie job window.

Commonly, by using flag file, solve the dependency of jobs. When the first job finished, it would 
leave a success flag file, indicating the job is successful. Before the job depending on the first job starts,
it will check the success flag file of the first job.

However, when in editing oozie job window, If you want to run the job manually, but the job depends on the other job,
You could fill the deps blank with the directory where the success flag file locates, such as '/warehouse/sdm/table/data_dt=xxx'.