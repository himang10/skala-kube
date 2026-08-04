apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{USER_NAME}}-linux-kubectl
  namespace: {{NAMESPACE}}
  labels:
    app: {{USER_NAME}}-linux-kubectl
spec:
  replicas: 1
  selector:
    matchLabels:
      app: {{USER_NAME}}-linux-kubectl
  template:
    metadata:
      labels:
        app: {{USER_NAME}}-linux-kubectl
    spec:
      containers:
        - name: linux
          image: {{DOCKER_REGISTRY}}/{{USER_NAME}}-linux-kubectl:1.0
          imagePullPolicy: Always
          env:
            - name: KUBECONFIG
              value: /root/.kube/config
          volumeMounts:
            - name: kubeconfig
              mountPath: /root/.kube
              readOnly: true
          resources:
            requests:
              cpu: 50m
              memory: 64Mi
            limits:
              cpu: 200m
              memory: 256Mi
      volumes:
        - name: kubeconfig
          configMap:
            name: {{USER_NAME}}-linux-kubeconfig
            defaultMode: 0600
