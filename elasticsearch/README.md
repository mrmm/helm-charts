# Elasticsearch Helm Chart

This image is using Fabric8's great [kubernetes discovery
plugin](https://github.com/fabric8io/elasticsearch-cloud-kubernetes) for
elasticsearch and their
[image](https://hub.docker.com/r/fabric8/elasticsearch-k8s/) as parent.

## Prerequisites Details

* Kubernetes 1.3 with alpha APIs enabled
* PV dynamic provisioning support on the underlying infrastructure

## PetSet Details
* http://kubernetes.io/docs/user-guide/petset/

## PetSet Caveats
* http://kubernetes.io/docs/user-guide/petset/#alpha-limitations

## Todo

[ ] Implement TLS/Auth/Security
[ ] Smarter upscaling/downscaling
[x] Solution for memory locking

## Chart Details
This chart will do the following:

* Implemented a dynamically scalable elasticsearch cluster using Kubernetes PetSets/Deployments
* Multi-role deployment: master, client and data nodes
* PetSet Supports scaling down without degrading the cluster

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install --name my-release incubator/elasticsearch
```

## Deleting the Charts

Deletion of the PetSet doesn't cascade to deleting associated Pods and PVCs. To delete them:

```
$ kubectl delete pods -l release=my-release,type=data
$ kubectl delete pvcs -l release=my-release,type=data
```

## Configuration

The following tables lists the configurable parameters of the elasticsearch chart and their default values.

|         Parameter         |           Description             |                         Default                          |
|---------------------------|-----------------------------------|----------------------------------------------------------|
| `Image`                   | Container image name              | `jetstack/elasticsearch-pet`                             |
| `ImageTag`                | Container image tag               | `2.3.4`                                                  |
| `ImagePullPolicy`         | Container pull policy             | `Always`                                                 |
| `ClientReplicas`          | Client node replicas (deployment) | `2`                                                      |
| `ClientCpuRequests`       | Client node requested cpu         | `25m`                                                    |
| `ClientMemoryRequests`    | Client node requested memory      | `256Mi`                                                  |
| `ClientCpuLimits`         | Client node requested cpu         | `100m`                                                   |
| `ClientMemoryLimits`      | Client node requested memory      | `512Mi`                                                  |
| `ClientHeapSize`          | Client node heap size             | `128m`                                                   |
| `MasterReplicas`          | Master node replicas (deployment) | `2`                                                      |
| `MasterCpuRequests`       | Master node requested cpu         | `25m`                                                    |
| `MasterMemoryRequests`    | Master node requested memory      | `256Mi`                                                  |
| `MasterCpuLimits`         | Master node requested cpu         | `100m`                                                   |
| `MasterMemoryLimits`      | Master node requested memory      | `512Mi`                                                  |
| `MasterHeapSize`          | Master node heap size             | `128m`                                                   |
| `DataReplicas`            | Data node replicas (petset)       | `3`                                                      |
| `DataCpuRequests`         | Data node requested cpu           | `250m`                                                   |
| `DataMemoryRequests`      | Data node requested memory        | `2Gi`                                                    |
| `DataCpuLimits`           | Data node requested cpu           | `1`                                                      |
| `DataMemoryLimits`        | Data node requested memory        | `4Gi`                                                    |
| `DataHeapSize`            | Data node heap size               | `1536m`                                                  |
| `DataStorage`             | Data persistent volume size       | `30Gi`                                                   |
| `DataStorageClass`        | Data persistent volume Class      | `anything`                                               |
| `DataStorageClassVersion` | Version of StorageClass           | `alpha`                                                  |
| `Component`               | Selector Key                      | `elasticsearch`                                          |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

## Select right storage class for SSD volumes

### AWS - Kubernetes 1.4

Create StorageClass for SSD-IOps

```
$ kubectl create -f - <<EOF
kind: wStorageClass
apiVersion: storage.k8s.io/v1beta1
metadata:
  name: ebs-high-iops
  annotations:
    ebs/aws-zone: eu-west-1a
    ebs/iopsPerGB: "50"
provisioner: kubernetes.io/aws-ebs
parameters:
  type: io1
  zone: eu-west-1a
  iopsPerGB: "50"
EOF
```
Create cluster with Storage class `ebs-high-iops` on Kubernetes 1.4+

```
$ helm install . --name my-release --set Data.Storage.Class=ebs-high-iops,Data.Storage.ClassVersion=beta

```
