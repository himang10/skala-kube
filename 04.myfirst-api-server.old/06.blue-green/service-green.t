apiVersion: v1
kind: Service
metadata:
  name: {{USER_NAME}}-{{SERVICE_NAME}}-new
  namespace: {{NAMESPACE}}
  labels:
    app: {{USER_NAME}}-{{SERVICE_NAME}}-new
spec:
  selector:
    app: {{USER_NAME}}-{{SERVICE_NAME}}-new
  ports:
    - name: http
      protocol: TCP
      port: 8080
      targetPort: 8080
    - name: mgmt
      protocol: TCP
      port: 8081
      targetPort: 8081
  type: ClusterIP


