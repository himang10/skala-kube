#!/bin/bash

# ============================================================
# 환경 변수 설정 (기본값 포함)
# ============================================================
BASE_URL="${BASE_URL:-http://localhost:8080}"
TOTAL_REQUESTS="${TOTAL_REQUESTS:-1000}"
CONCURRENCY="${CONCURRENCY:-10}"
INTERVAL_SEC="${INTERVAL_SEC:-1}"

ENDPOINTS=(
  "/api/users"
  "/api/developer-info"
)

# ============================================================
# hey 설치 확인
# ============================================================
if ! command -v hey &> /dev/null; then
  echo "[ERROR] 'hey' 가 설치되어 있지 않습니다."
  echo "  brew install hey  또는  go install github.com/rakyll/hey@latest"
  exit 1
fi

echo "==============================="
echo " BASE_URL       : ${BASE_URL}"
echo " TOTAL_REQUESTS : ${TOTAL_REQUESTS}"
echo " CONCURRENCY    : ${CONCURRENCY}"
echo " INTERVAL       : ${INTERVAL_SEC}s 간격"
echo "==============================="

# ============================================================
# 각 엔드포인트에 대해 hey 실행 (INTERVAL_SEC 간격)
# ============================================================
for ENDPOINT in "${ENDPOINTS[@]}"; do
  URL="${BASE_URL}${ENDPOINT}"
  echo ""
  echo "[INFO] 요청 시작: ${URL}"
  echo "       총 ${TOTAL_REQUESTS}개 / 동시 ${CONCURRENCY}개"

  hey \
    -n "${TOTAL_REQUESTS}" \
    -c "${CONCURRENCY}" \
    -H "Accept: application/json" \
    "${URL}"

  echo "[INFO] 완료: ${URL}"
  echo "       ${INTERVAL_SEC}초 대기 후 다음 엔드포인트 실행..."
  sleep "${INTERVAL_SEC}"
done

echo ""
echo "[DONE] 모든 요청 완료."
