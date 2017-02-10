# kube-data-downloader

This repository contains docker image to pass HEP-specific data into kubernetes pod.
Using [init-container](https://kubernetes.io/docs/concepts/abstractions/init-containers/) kubernetes feature it passes data from HEP-specific backends to another container which contains only computational logic.





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
docker run -v `pwd`/bootstrap-example:/bootstrap -v `pwd`/job-input:/input -ti scr4t/kube-data-downloader /bin/bash -c -l "cd bootstrap; ./download.sh"
```


Kubernetes job description would look like this:

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: test-job
spec:
  template:
    metadata:
      name: test-job
      annotations:
        pod.beta.kubernetes.io/init-containers: '[
          {
              "name": "download-data",
              "image": "scr4t/kube-data-downloader:latest",
              "command": ["/bin/bash", "-l", "-c", "cd /bootstrap; source download.sh"],
              "imagePullPolicy": "Always",
              "restartPolicy": "Never",
              "volumeMounts": [
                  {
                      "name": "bootstrap-volume",
                      "mountPath": "/bootstrap"
                  },
                  {
                      "name": "input-volume",
                      "mountPath": "/input"
                  }
              ]
          }
        ]'
    spec:
      restartPolicy: Never
      containers:
        - image: scr4t/ship:01.03.2016
          name: test-job
          imagePullPolicy: Always
          command: ["/bin/bash", "-l", "-c", "cp /input/56211dbf9e74775867df168f.stderr /output/56211dbf9e74775867df168f.stderr; sleep 1"] # this file is used in bootstrap-example
          volumeMounts:
          - mountPath: /output
            name: output-volume
          - mountPath: /input
            name: input-volume
      volumes:
      - name: bootstrap-volume
        hostPath:
          path: /Users/user/path/to/bootstrap-example
      - name: input-volume
        emptyDir: {}
      - name: output-volume
        hostPath:
          path: /path/to/output/storage
```


