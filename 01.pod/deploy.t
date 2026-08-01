apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{USER_NAME}}-deploy-test
  namespace: {{NAMESPACE}}
  labels:
    app: {{USER_NAME}}-deploy-test
spec:
  replicas: 1
  selector:
    matchLabels:
      app: {{USER_NAME}}-deploy-test
  template:
    metadata:
      annotations:
        update: {{HASHCODE}}
      labels:
        app: {{USER_NAME}}-deploy-test
    spec:
      serviceAccountName: default
      containers:
        - name: nginx
          image: nginx:mainline-alpine
          imagePullPolicy: Always
          env:
            - name: USER_NAME
              value: {{USER_NAME}}

