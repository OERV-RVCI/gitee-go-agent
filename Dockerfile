FROM hub.oepkgs.net/oerv-ci/openeuler:24.03-lts-sp1

ARG GITEE_GO_WORKSPACE="/srv/gitee-go"
ARG FILE_DOWNLOAD_URI="https://gitee-agent-shell.gz.bcebos.com" 
ARG AGENT_DOWNLOAD_PATH="/agent/agent.jar" 

ENV GITEE_AGENT_UUID=1234567

RUN dnf makecache && \
dnf install java-17-openjdk java-17-openjdk-devel java-17-openjdk-headless curl hostname wget -y && \
dnf clean all 

RUN mkdir -p ${GITEE_GO_WORKSPACE} 
RUN wget -P ${GITEE_GO_WORKSPACE} https://repo.huaweicloud.com/repository/maven/net/java/dev/jna/jna/5.8.0/jna-5.8.0.jar
RUN curl -m 180 -H "Redirect-Uri:${FILE_DOWNLOAD_URI}" "${FILE_DOWNLOAD_URI}${AGENT_DOWNLOAD_PATH}" -o ${GITEE_GO_WORKSPACE}/agent.jar

WORKDIR ${GITEE_GO_WORKSPACE}

CMD ["sh","-c","/usr/lib/jvm/java-17-openjdk/bin/java --add-opens java.base/java.net=ALL-UNNAMED -cp agent.jar:jna-5.8.0.jar -Dfile.encoding=UTF-8 com.baidu.agile.agent.Main -s https://server-agent.gitee.com/gitee_sa_server -t ${GITEE_AGENT_UUID}"]
