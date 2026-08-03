apiVersion: v1
kind: Pod
metadata:
  name: {{USER_NAME}}-webserver
  namespace: {{NAMESPACE}}
  labels:
    app: {{USER_NAME}}-webserver
spec:
  containers:
  - name: webserver
    image: {{DOCKER_REGISTRY}}/skala25a/skala-webserver:1.0 
    imagePullPolicy: Always
    env:
    - name: USER_NAME
      value: {{USER_NAME}}
