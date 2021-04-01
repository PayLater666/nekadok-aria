FROM narima/megaria:latest

WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app

RUN apt-get -qq update && \
    apt-get install -y software-properties-common && \
    rm -rf /var/lib/apt/lists/* && \
    apt-add-repository non-free && \
    apt-get -qq update && \
    apt-get -qq install -y p7zip-full p7zip-rar curl pv jq locales wget python3-lxml && \
    apt-get purge -y software-properties-common

COPY requirements.txt .
COPY extract /usr/local/bin
COPY pextract /usr/local/bin
RUN chmod +x /usr/local/bin/extract && chmod +x /usr/local/bin/pextract
RUN pip3 install --no-cache-dir -r requirements.txt

# aria stuff & ffmpeg
RUN mkdir -p /tmp/ && \
         cd /tmp/ && \
         wget -O /tmp/aria.tar.gz https://github.com/P3TERX/Aria2-Pro-Core/releases/download/1.35.0_2021.02.19/aria2-1.35.0-static-linux-amd64.tar.gz && \
         wget -O /tmp/ffmpeg.tar.xz https://johnvansickle.com/ffmpeg/builds/ffmpeg-git-amd64-static.tar.xz && \
         tar -xzvf aria.tar.gz && \
         tar -xvf ffmpeg.tar.xz && \
         cp -v aria2c /usr/bin/
         cd ffmpeg-git* && \
         cp -v ffmpeg ffprobe /usr/bin/ && \
         rm -rf /tmp/ffmpeg* && \
         
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
COPY . .
COPY netrc /root/.netrc
RUN chmod +x aria.sh

CMD ["bash","start.sh"]

