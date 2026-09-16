apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{USER_NAME}}-{{SERVICE_NAME}}-new
  namespace: {{NAMESPACE}}
  labels:
    app: {{USER_NAME}}-{{SERVICE_NAME}}-new
spec:
  replicas: {{REPLICAS}}
  selector:
    matchLabels:
      app: {{USER_NAME}}-{{SERVICE_NAME}}-new
  template:
    metadata:
      annotations:
        prometheus.io/scrape: 'true'
        prometheus.io/port: '8080'
        prometheus.io/path: '/python/prometheus'
        update: {{HASHCODE}}
      labels:
        app: {{USER_NAME}}-{{SERVICE_NAME}}-new
    spec:
      containers:
      - name: {{IMAGE_NAME}}
        image: {{DOCKER_REGISTRY}}/{{PROJECT_NAME}}/{{USER_NAME}}-{{IMAGE_NAME}}:2.0
        imagePullPolicy: Always
        env:
        - name: USER_NAME
          value: {{USER_NAME}}
        - name: NAMESPACE
          value: {{NAMESPACE}}
        livenessProbe:
          httpGet:
            path: /python/health/liveness
            port: 8080
          initialDelaySeconds: 10
          periodSeconds: 5
          failureThreshold: 3
          timeoutSeconds: 5
        readinessProbe:
          httpGet:
            path: /python/health/readiness
            port: 8080
          initialDelaySeconds: 10
          periodSeconds: 5
          failureThreshold: 3
          timeoutSeconds: 5
