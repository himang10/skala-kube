apiVersion: v1
kind: Pod
metadata:
  name: {{USER_NAME}}-pod-test
  namespace: {{NAMESPACE}}
  labels:
    app: {{USER_NAME}}-pod-test
spec:
  serviceAccountName: default
  containers:
  - name: nginx
    image:  nginx:latest
    imagePullPolicy: Always
    env:
    - name: USER_NAME
      value: {{USER_NAME}}
