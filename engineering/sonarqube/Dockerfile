FROM java:openjdk-8u45-jre

MAINTAINER soulteary <soulteary@gmail.com>

ENV NODE_VERSION 10.8.0
ENV SONAR_RUNNER_VERSION 3.2.0.1227
ENV SONAR_RUNNER_DIR sonar-scanner
ENV SONAR_RUNNER_HOME /opt/${SONAR_RUNNER_DIR}
ENV SONAR_RUNNER_PACKAGE sonar-scanner-cli-${SONAR_RUNNER_VERSION}-linux.zip
ENV HOME ${SONAR_RUNNER_HOME}

WORKDIR /opt

RUN wget https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/${SONAR_RUNNER_PACKAGE} && \
    unzip ${SONAR_RUNNER_PACKAGE} && \
    mv ${SONAR_RUNNER_DIR}-${SONAR_RUNNER_VERSION}-linux ${SONAR_RUNNER_DIR} && \
    rm ${SONAR_RUNNER_PACKAGE}

RUN groupadd -r sonar && \
    useradd -r -s /usr/sbin/nologin -d ${SONAR_RUNNER_HOME} -c "Sonar service user" -g sonar sonar && \
    chown -R sonar:sonar ${SONAR_RUNNER_HOME} && \
    mkdir -p /data && \
    chown -R sonar:sonar /data

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash && \
    export NVM_DIR="$HOME/.nvm" && \. "$NVM_DIR/nvm.sh" && \
    nvm install ${NODE_VERSION} && nvm alias default ${NODE_VERSION}

ENV JAVA_CERTS_DIR "$JAVA_HOME/jre/lib/security"

ADD /ssl/*.crt /tmp/

ADD run.sh ${SONAR_RUNNER_HOME}/bin/

# https://stackoverflow.com/questions/41497871/importing-self-signed-cert-into-dockers-jre-cacert-is-not-recognized-by-the-ser
RUN ls /tmp/*.crt | xargs -I {} keytool -importcert -storepass changeit -noprompt -trustcacerts -alias {} -file {} -keystore "$SONAR_RUNNER_HOME$JAVA_CERTS_DIR/cacerts" && \
    cp /tmp/*.crt /usr/share/ca-certificates && update-ca-certificates && \
    rm -rf /tmp/*.crt && \
    ln ${SONAR_RUNNER_HOME}/bin/run.sh /bin/sonar

# https://stackoverflow.com/questions/28740785/error-in-sonarqube-when-launching-svn-blame
RUN echo "sonar.host.url=https://sonar.lab.com" >> ${SONAR_RUNNER_HOME}/conf/sonar-scanner.properties && \
    echo "sonar.projectBaseDir=/data"           >> ${SONAR_RUNNER_HOME}/conf/sonar-scanner.properties && \
    echo "sonar.sources=/data"                  >> ${SONAR_RUNNER_HOME}/conf/sonar-scanner.properties && \
    echo "sonar.scm.disabled=true"              >> ${SONAR_RUNNER_HOME}/conf/sonar-scanner.properties

USER sonar

VOLUME /data

ENTRYPOINT ["/bin/sonar"]