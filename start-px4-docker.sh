#!/bin/bash
echo "PX4 Docker Environment Setup"
echo "=============================="

# Docker 이미지 빌드
echo "Building Docker image..."
docker build -t px4-dev:latest .

# X11 포워딩 설정 (Linux/WSL)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    export DISPLAY=:0
    xhost +local:docker
fi

# 로그 디렉토리 생성
mkdir -p logs

echo "Starting PX4 simulation..."
echo "Gazebo GUI should appear shortly."
echo "Connect QGroundControl to localhost:14551"
echo ""
echo "To stop: docker-compose down"

# Docker Compose 실행
docker-compose up
