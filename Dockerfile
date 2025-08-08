FROM ubuntu:22.04

# 환경 변수 설정
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Seoul
ENV DISPLAY=:0

# 기본 패키지 설치
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    build-essential \
    cmake \
    python3 \
    python3-pip \
    pkg-config \
    software-properties-common \
    lsb-release \
    gnupg2 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# CMake 3.22 고정 (jsoncpp 호환성)
RUN apt-get update && apt-get install -y cmake=3.22.1-1ubuntu1.22.04.2 \
    && apt-mark hold cmake

# Gazebo Harmonic 설치
RUN wget https://packages.osrfoundation.org/gazebo.gpg -O /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg \
    && echo "deb [arch=\$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable \$(lsb_release -cs) main" | tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null \
    && apt-get update \
    && apt-get install -y gz-harmonic \
    && rm -rf /var/lib/apt/lists/*

# PX4 의존성 설치
RUN pip3 install --user mavproxy pymavlink

# 작업 디렉토리 설정
WORKDIR /home/px4

# PX4-Autopilot 클론
RUN git clone --recursive https://github.com/PX4/PX4-Autopilot.git

# PX4 의존성 설치 스크립트 실행
RUN cd PX4-Autopilot && bash Tools/setup/ubuntu.sh --no-nuttx

# PX4 빌드
RUN cd PX4-Autopilot && make px4_sitl_default

# Gazebo 환경 변수 설정
ENV GZ_SIM_SYSTEM_PLUGIN_PATH=/usr/lib/x86_64-linux-gnu/gz-sim-8/plugins
ENV GZ_SIM_RESOURCE_PATH=/usr/share/gz/gz-sim8

# 포트 노출
EXPOSE 14550 14570 14580

# 시작 스크립트 생성
RUN echo '#!/bin/bash\ncd /home/px4/PX4-Autopilot\nexec "\$@"' > /start.sh \
    && chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
CMD ["make", "px4_sitl", "gz_x500"]
