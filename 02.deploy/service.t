apiVersion: v1
kind: Service
metadata:
  name: {{USER_NAME}}-webserver
  namespace: {{NAMESPACE}}
  labels:
    app: {{USER_NAME}}-webserver
spec:
  type: ClusterIP
  selector:
    app: {{USER_NAME}}-webserver
  ports:
    - name: http
      protocol: TCP
      port: {{CONTAINER_PORT}}
      targetPort: {{CONTAINER_PORT}}
    - name: mgmt
      protocol: TCP
      port: 8081
      targetPort: 8081


