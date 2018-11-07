#!/bin/bash
kubectl delete deployment,service,pvc -l app=gitlab
kubectl delete pv local-volume-1 local-volume-2 local-volume-3
