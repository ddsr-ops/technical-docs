> Task :metadata-ingestion:codegen FAILED
which: no jq in (/root/datahub/metadata-ingestion/venv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin)
jq is not installed. Please install jq and rerun (https://stedolan.github.io/jq/)

yum install epel-release   
yum list jq  
yum install jq  