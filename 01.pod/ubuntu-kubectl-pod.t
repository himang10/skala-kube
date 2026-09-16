apiVersion: v1
kind: Pod
metadata:
  name: {{USER_NAME}}-ubuntu-kubectl
  namespace: {{NAMESPACE}}
  labels:
    app: {{USER_NAME}}-ubuntu-kubectl
spec:
  containers:
    - name: linux
      image: {{DOCKER_REGISTRY}}/library/skala-ubuntu-kubectl:1.0
      imagePullPolicy: Always
      env:
        - name: KUBECONFIG
          value: /root/.kube/config
      volumeMounts:
        - name: kubeconfig
          mountPath: /root/.kube
          readOnly: true
  volumes:
    - name: kubeconfig
      configMap:
        name: skala-ubuntu-kubeconfig
        defaultMode: 0600
