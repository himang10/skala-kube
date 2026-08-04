#!/usr/bin/env bash

set -uo pipefail

# 이 스크립트가 있는 위치를 기준으로 YAML 파일을 찾습니다.
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# 삭제 대상 namespace 목록
NAMESPACES=(
  class-0
  class-{6..10}
  skala-practice
)

# 삭제할 Kubernetes YAML 목록
YAML_FILES=(
  attach-pvc-deploy.yaml
  kubectl-deploy.yaml
  resources.yaml
  kubeconfig-secret.yaml
)

# YAML 파일이 없으면 어떤 리소스를 삭제할지 확인할 수 없으므로 중단합니다.
missing_file=0
for yaml_file in "${YAML_FILES[@]}"; do
  if [[ ! -f "${SCRIPT_DIR}/${yaml_file}" ]]; then
    echo "[ERROR] YAML 파일을 찾을 수 없습니다: ${SCRIPT_DIR}/${yaml_file}" >&2
    missing_file=1
  fi
done

if (( missing_file != 0 )); then
  exit 1
fi

# YAML 하나마다 모든 namespace에서 리소스를 삭제합니다.
failed_count=0
for yaml_file in "${YAML_FILES[@]}"; do
  for namespace in "${NAMESPACES[@]}"; do
    echo "[DELETE] ${yaml_file} -> namespace/${namespace}"

    if ! kubectl delete \
      -f "${SCRIPT_DIR}/${yaml_file}" \
      -n "${namespace}" \
      --ignore-not-found=true; then
      echo "[ERROR] 삭제 실패: ${yaml_file} -> namespace/${namespace}" >&2
      ((failed_count += 1))
    fi
  done
done

if (( failed_count != 0 )); then
  echo "[ERROR] 총 ${failed_count}개 삭제 작업이 실패했습니다." >&2
  exit 1
fi

echo "[DONE] 모든 YAML 리소스를 모든 namespace에서 삭제했습니다."
