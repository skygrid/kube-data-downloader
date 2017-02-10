# kube-data-downloader

This repository contains docker image to pass HEP-specific data into kubernetes pod.





```
                         +--------------------------------------------------------+
                         |                                                        |
                         |                                                        |
+-----------+            |   +-------------------+              +-------------+   |
|           |            |   |                   |              |             |   |
| LHC Grid  |            |   |  Data downloader  |              | Computation |   |
| Storage   | +------------> |  (this repo)      | +--------->  | logic       |   |
|           |            |   |                   |              |             |   |
+-----------+            |   +-------------------+              +-------------+   |
                         |                                                        |
                         |      Init container                                    |
                         |                                                        |
                         |                                                        |
                         +--------------------------------------------------------+

                                             Kubernetes Pod
```



## Examples

Consider you want to pass data through `job-input` directory:

```
docker run -v `pwd`/bootstrap-example:/bootstrap -v `pwd`/job-input:/input -ti 54d6234aefbd /bin/bash -c -l "cd bootstrap; ./download.sh"
```

