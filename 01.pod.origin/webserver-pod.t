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
    image: {{DOCKER_REGISTRY}}/{{PROJECT_NAME}}/{{USER_NAME}}-webserver:1.0 
    imagePullPolicy: Always
    env:
    - name: USER_NAME
      value: {{USER_NAME}}
    - name: CLASS_NAME
      value: {{NAMESPACE}}
