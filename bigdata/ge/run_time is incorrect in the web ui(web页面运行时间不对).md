Refer to https://github.com/great-expectations/great_expectations/issues/6307

change this line  `run_time = run_time or datetime.datetime.now()` in the file  `checkpoint/checkpoint.py`
to `run_time = run_time or datetime.datetime.utcnow()`