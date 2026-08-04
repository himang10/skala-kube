FROM ubuntu:24.04

ARG KUBECTL_VERSION=v1.35.0
ARG TARGETARCH

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        vim \
    && curl -fsSLo /usr/local/bin/kubectl \
        "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl" \
    && chmod 0755 /usr/local/bin/kubectl \
    && kubectl version --client=true \
    && rm -rf /var/lib/apt/lists/*

ENV KUBECONFIG=/root/.kube/config

CMD ["sleep", "infinity"]
