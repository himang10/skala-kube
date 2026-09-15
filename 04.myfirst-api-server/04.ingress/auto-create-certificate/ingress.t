apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
  name: {{USER_NAME}}-myfirst-ingress
  namespace: {{NAMESPACE}}
  labels:
    app: {{USER_NAME}}-myfirst-ingress
spec:
  ingressClassName: {{INGRESS_CLASS_NAME}}
  rules:
  - host: {{USER_NAME}}-ingress.cloud.skala-{{LOCATION}}.com
    http:
      paths:
      - backend:
          service:
            name: {{USER_NAME}}-{{SERVICE_NAME}}
            port:
              number: 8080
        path: /
        pathType: Prefix
  tls:
  - hosts:
    - '{{USER_NAME}}-ingress.cloud.skala-{{LOCATION}}.com'
    secretName: {{USER_NAME}}-ingress-cloud-tls-cert
