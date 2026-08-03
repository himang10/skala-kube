# Agent 작업 가이드

이 문서는 `03.sample-container` 프로젝트에서 수행할 리팩토링 및 K8s 배포 구성 작업의 지시사항을 정리한 것이다.

이 Agent.md는 AI가 실제 코딩 작업을 수행할 때 참고하는 가이드 문서로 사용된다.

## 배경

- `01.spring-backend-v1.0` : Spring Boot 기반 백엔드. Thymeleaf 뷰(`HomeViewController`, `OrderViewController`, `ProductViewController`, `UserViewController` 및 `src/main/resources/templates/**`)와 REST API 컨트롤러가 함께 존재.
- `02.fastapi-backend-v2.0` : FastAPI 기반 백엔드. `fastserver.py.old`에 `/api/users` CRUD(GET/POST/PUT/DELETE), `/python/*` 상태·메트릭 API가 인메모리 데이터로 구현되어 있음. `CORSMiddleware`는 import만 되어 있고 아직 미적용 상태.
- `03.frontend` : 현재는 nginx 기반의 단순 `index.html` 정적 페이지로 구성되어 있으며, 01의 화면과 무관한 기본 코드 상태.

## 작업 목표

1. **Thymeleaf 화면 분리**
   - `01.spring-backend-v1.0`에 있는 Thymeleaf 기반 화면(View Controller + templates + static 리소스)을 `03.frontend`로 분리 이관한다.
   - `03.frontend`의 기존 기본 코드(현재의 `index.html`, nginx 설정 등)는 무시하고, 01의 화면 구성을 옮겨온다.
   - **중요: `03.frontend`는 Spring Boot 같은 2번째 서버 프로세스가 아니라, 정적 리소스(HTML/CSS/JS)만 nginx로 서빙하는 구조여야 한다.**
     Thymeleaf의 서버 사이드 렌더링(`th:each`, `th:text` 등)은 정적 HTML + 브라우저 JavaScript(fetch)로 변환한다.
     01의 REST API(`/api/**`) 호출은 nginx가 `location /api { proxy_pass http://backend:8080; }` 형태로 프록시해서, 브라우저 입장에서는 같은 오리진처럼 보이게 한다(CORS 불필요). 이때 01의 k8s Service/로컬 컨테이너 이름은 반드시 `backend`로 맞춘다.
   - 분리 후 `03.frontend`가 별도의 컨테이너로 **단독 실행 가능**해야 한다 (01 백엔드와는 API로만 통신하는 구조).

2. **K8s 배포 구성**
   - `01.spring-backend-v1.0`과 `03.frontend` 각각에 대해 Deployment, Service를 구성한다.
   - Ingress는 `03.frontend` 쪽에만 구성한다.
   - `02.fastapi-backend-v2.0`에도 Deployment, Service를 구성한다. 구조는 01과 동일하게 만들되(ClusterIP, 동일한 리소스 형태), 이름/라벨만 `backend-v2`로 다르게 해서 01(`backend`)과 구분한다. 02에는 Ingress를 두지 않는다.
   - K8s 리소스 매니페스트는 각 프로젝트 디렉토리 하위 `k8s/` 폴더에 작성한다.
     - `01.spring-backend-v1.0/k8s/`
     - `02.fastapi-backend-v2.0/k8s/`
     - `03.frontend/k8s/`

3. **코드 작성 원칙 (교육용 자료)**
   - 불필요한 코드/설정은 제거하고 최대한 단순하게 작성한다.
   - 학생들이 학습할 때 헷갈리지 않도록 명확하고 간결하게 구성한다.
   - 이미지/아이콘 파일은 생성하지 않는다.

4. **02.fastapi-backend-v2.0 ↔ 03.frontend 연동**
   - `02.fastapi-backend-v2.0`을 `03.frontend`에서 API로 호출 가능하도록 수정한다.
   - 01과 달리 02는 nginx 프록시를 거치지 않고, **브라우저(JavaScript)가 02의 주소를 직접 fetch로 호출**하는 방식으로 연동한다. 그래서 02 쪽에는 CORS 허용 설정이 반드시 필요하다.
   - 이미 구현되어 있는 `/api/users` CRUD를 그대로 활용하고, 새로운 기능/엔드포인트를 추가로 설계하지 않는다.
   - 연동에 필요한 최소한의 조치만 수행한다 (예: `CORSMiddleware` 적용 등). 인증, DB 연동, 별도 서비스 레이어 추가 등 범위를 넘어서는 작업은 하지 않는다.
   - 목표는 "03.frontend의 한 화면에서 fetch로 02의 API를 호출해 데이터를 보여주는 것"까지이며, 그 이상 복잡하게 만들지 않는다.

5. **문서화**
   - 작업 완료 후 전체 내용을 정리한 최종 `README.md`를 아래 두 위치에 작성한다.
     - `01.spring-backend-v1.0/README.md`
     - `03.frontend/README.md`
   - README에는 각 컴포넌트가 무엇을 하는 코드인지, 어떻게 실행/배포하는지 설명을 포함한다.

6. **04.vue-frontend (03.frontend의 Vue.js 버전)**
   - `03.frontend`와 동일한 화면/기능을 Vue 3 + Vite + Vue Router 기반 SPA로 다시 만든 프로젝트. `03.frontend`를 대체하는 것이 아니라 나란히 존재하는 별도 프로젝트다.
   - API 호출 방식과 백엔드 연동 원칙(01은 같은 오리진 `/api`로, 02는 브라우저가 직접 CORS로 호출)은 03과 동일하게 유지한다.
   - 03과 달리 빌드 단계가 필요하므로 Dockerfile은 멀티스테이지(1단계 `npm run build`, 2단계 nginx로 정적 파일 서빙)로 구성한다.
   - Vue Router는 history 모드를 사용하므로, nginx `default.conf`에 `try_files $uri $uri/ /index.html;` 형태의 SPA 폴백이 반드시 필요하다 (03에는 없던 설정).
   - `04.vue-frontend/README.md`에도 03과의 차이점을 포함해 작성한다.

## k8s 매니페스트 작성 규칙 (`.t` 템플릿)
- 이 저장소는 각 프로젝트의 `k8s/` 폴더에 `deployment.t`, `service.t`, `ingress.t` 같은 템플릿 파일을 두고, `{{USER_NAME}}`, `{{NAMESPACE}}`, `{{PROJECT_NAME}}`, `{{DOCKER_REGISTRY}}`, `{{HASHCODE}}` 같은 플레이스홀더를 쓴다.
- 실제 배포에 쓰는 `deployment.yaml`/`service.yaml`/`ingress.yaml`은 이 `.t` 파일을 바탕으로 **외부 도구(이 저장소 밖의 파이프라인)가 생성**한다. `k8s/.generated` 파일이 어떤 파일이 자동 생성 대상인지 표시한다.
- 따라서 k8s 리소스를 수정할 때는 **`.t` 템플릿을 고친다**. 이미 생성되어 있는 `.yaml`은 직접 손대지 않는다 (다음 생성 시 덮어써지고, 값이 실제 배포 환경과 어긋날 수 있다).
- 01의 REST API/Actuator를 가리키는 Service 이름은 `webserver`를 그대로 쓴다(템플릿 안에서 `{{USER_NAME}}`로 감싸지 않음). frontend 계열 프로젝트(03, 04) 자신의 리소스 이름은 `{{USER_NAME}}-frontend`, `{{USER_NAME}}-vue-frontend`처럼 프로젝트별 접미사를 붙인다.

## 체크리스트

- [ ] 01의 Thymeleaf 관련 코드(View Controller, templates, static) 파악 및 03으로 이관
- [ ] 03.frontend 기존 기본 코드 제거 후 교체
- [ ] 03.frontend 단독 실행 가능하도록 구성 (01과는 API 통신)
- [ ] 01.spring-backend-v1.0/k8s/ : Deployment, Service 작성 (이름/라벨 `backend`)
- [ ] 02.fastapi-backend-v2.0/k8s/ : Deployment, Service 작성 (01과 동일 구조, 이름/라벨 `backend-v2`)
- [ ] 03.frontend/k8s/ : Deployment, Service, Ingress 작성
- [ ] 02.fastapi-backend-v2.0에 CORS 등 최소 설정 적용하여 03.frontend와 연동 (단순 연동까지만, 과도한 확장 금지)
- [ ] 불필요한 코드 정리 (교육용 목적에 맞게 단순화)
- [ ] 이미지/아이콘 생성 금지 준수
- [ ] 01.spring-backend-v1.0/README.md 작성
- [ ] 03.frontend/README.md 작성
- [ ] 04.vue-frontend : 03.frontend를 Vue 3 + Vite + Vue Router SPA로 재작성, 멀티스테이지 Dockerfile, SPA 폴백(nginx try_files), k8s `.t` 템플릿, README 작성
