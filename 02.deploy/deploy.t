apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{USER_NAME}}-webserver
  namespace: {{NAMESPACE}}
  labels:
    app: {{USER_NAME}}-webserver
spec:
  replicas: 1
  selector:
    matchLabels:
      app: {{USER_NAME}}-webserver
  template:
    metadata:
      annotations:
        prometheus.io/scrape: 'true'
        prometheus.io/port: '8080'
        prometheus.io/path: '/actuator/prometheus'
        update: {{HASHCODE}}
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
        - name: NAMESPACE
          value: {{NAMESPACE}}
        - name: SPRING_PROFILES_ACTIVE  
          value: "local"  
