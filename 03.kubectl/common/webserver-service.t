apiVersion: v1
kind: Service
metadata:
  name: skala-webserver
  namespace: {{NAMESPACE}}
spec:
  selector:
    app: skala-webserver
  ports:
    - name: http
      protocol: TCP
      port: 8080
      targetPort: 8080
  type: ClusterIP


