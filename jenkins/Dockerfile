FROM jenkins/jenkins:lts
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG /var/jenkins_home/config

COPY --chown=jenkins:jenkins plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt 

USER root
RUN apt-get update -y && \
    apt-get install -y gnupg software-properties-common curl && \
    curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    apt-get update && \
    apt-get install terraform && \
    curl -o vault.zip https://releases.hashicorp.com/vault/1.9.3/vault_1.9.3_linux_amd64.zip && \
    unzip vault.zip && \
    mv vault /usr/bin && \
    rm -rf vault.zip && \
    chown jenkins:jenkins /usr/bin/vault

USER jenkins

EXPOSE 8080

#COPY run.sh ./
#CMD ./run.sh

ENTRYPOINT ["/sbin/tini","--","/usr/local/bin/jenkins.sh"]