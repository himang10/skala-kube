# 03.frontend Ingress
# - 클러스터 외부에서 접근하는 진입점. 01(백엔드)에는 Ingress를 두지 않고,
#   반드시 이 03.frontend를 거쳐서만 외부에서 접근하도록 구성한다.
# - /api, /python, /actuator 는 nginx 컨테이너를 거치지 않고 Ingress 단계에서
#   바로 01의 Service(webserver:8080)로 라우팅한다. (그 외 경로는 정적 파일을 서빙하는 frontend로)
# - host는 실습 환경에 맞게 바꿔서 사용한다.
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
          - path: /api
            pathType: Prefix
            backend:
              service:
                name: {{USER_NAME}}-{{SERVICE_NAME}}
                port:
                  number: 8080
          - path: /actuator
            pathType: Prefix
            backend:
              service:
                name: {{USER_NAME}}-{{SERVICE_NAME}}
                port:
                  number: 8080
          - path: /
            pathType: Prefix
            backend:
              service:
                name: {{USER_NAME}}-myfirst-frontend
                port:
                  number: 8080
  tls:
    - hosts:
      - {{USER_NAME}}-ingress.cloud.skala-{{LOCATION}}.com
      secretName: {{USER_NAME}}-ingress-cloud-tls-cert
