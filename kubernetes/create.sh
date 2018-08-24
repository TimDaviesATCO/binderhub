kops update cluster \
        --name=binder.geo-analytics.io \
        --state=s3://core.binder.kubernetes.state.store \
        --dns-zone=binder.geo-analytics.io \
        --out=. \
        --target=terraform \
        --zones ap-southeast-2a,ap-southeast-2b \
        --master-zones ap-southeast-2b \
        --node-size t2.medium \
        --master-size t2.medium
