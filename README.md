# PX4 SITL + Gazebo Harmonic Docker Environment

이 Docker 환경은 PX4 드론 시뮬레이션을 위해 구성되었습니다.

## 포함된 구성요소
- Ubuntu 22.04 기반
- PX4-Autopilot v1.16.0
- Gazebo Harmonic 8.9.0
- MAVProxy
- CMake 3.22 (jsoncpp 호환성)

## 사용 방법

### 1. 환경 준비
```bash
# Docker 및 Docker Compose 설치 필요
# Windows의 경우 Docker Desktop 설치
```

### 2. 이미지 빌드 및 실행
```bash
./start-px4-docker.sh
```

### 3. QGroundControl 연결
- 주소: localhost
- 포트: 14551
- 프로토콜: UDP

## 수동 실행
```bash
# 이미지 빌드
docker build -t px4-dev:latest .

# 컨테이너 실행
docker-compose up

# 또는 단독 실행
docker run -it --rm \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  -p 14550:14550/udp \
  -p 14570:14570/udp \
  -p 14580:14580/udp \
  px4-dev:latest
```

## 포트 정보
- 14550: MAVProxy 입력
- 14570: PX4 MAVLink 출력  
- 14580: PX4 보조 포트
- 14551: QGroundControl 연결 (MAVProxy 출력)

## 트러블슈팅
- Gazebo GUI가 안 보이는 경우: X11 포워딩 확인
- 연결 안 되는 경우: 방화벽 설정 확인
- 빌드 실패 시: Docker 메모리 할당 확인 (최소 4GB 권장)
