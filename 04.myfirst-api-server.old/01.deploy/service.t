apiVersion: v1
kind: Service
metadata:
  name: {{USER_NAME}}-myfirst-api-server
  namespace: {{NAMESPACE}}
  labels:
    app: {{USER_NAME}}-myfirst-api-server
spec:
  type: ClusterIP
  selector:
    app: {{USER_NAME}}-myfirst-api-server
  ports:
    - name: http
      protocol: TCP
      port: 8080
      targetPort: 8080
    - name: mgmt
      protocol: TCP
      port: 8081
      targetPort: 8081


