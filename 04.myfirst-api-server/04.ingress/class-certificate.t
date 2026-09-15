# *.cloud.skala-ai.com 와일드카드 인증서
# - xxx.cloud.skala-ai.com 형태의 서브도메인을 여러 개 사용하더라도
#   이 인증서 하나(시크릿 하나)를 공통으로 공유해서 쓸 수 있도록 발급한다.
# - 와일드카드 인증서는 HTTP-01 challenge로는 발급이 불가능하므로,
#   letsencrypt-prod ClusterIssuer가 DNS-01 challenge를 지원해야 한다.
# - 발급된 인증서는 spec.secretName 에 지정된 시크릿(class-0 네임스페이스)에 저장되며,
#   같은 네임스페이스의 여러 Ingress에서 tls.secretName 으로 동일하게 참조하면 된다.
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: wildcard-{{NAMESPACE}}-skala-{{LOCATION}}-com
  namespace: {{NAMESPACE}}
spec:
  secretName: wildcard-{{NAMESPACE}}-skala-{{LOCATION}}-com-tls
  issuerRef:
    name: letsencrypt-prod
    kind: ClusterIssuer
  commonName: '*.{{NAMESPACE}}.skala-{{LOCATION}}.com'
  dnsNames:
    - '*.{{NAMESPACE}}.skala-{{LOCATION}}.com'
    - '{{NAMESPACE}}.skala-{{LOCATION}}.com'
