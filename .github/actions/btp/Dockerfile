FROM buildpack-deps:stretch-curl

# Install latest CF CLI (auto-updating)
RUN curl -L "https://packages.cloudfoundry.org/stable?release=linux64-binary&source=github" | tar -zx && \
    mv cf /usr/local/bin/cf && \
    chmod +x /usr/local/bin/cf

# https://blogs.sap.com/2021/09/01/sap-tech-bytes-btp-cli-installation/
RUN curl -s -O --location --url "https://raw.githubusercontent.com/SAP-samples/sap-tech-bytes/2021-09-01-btp-cli/getbtpcli" && \
    chmod +x getbtpcli && \
    echo | ./getbtpcli && \
    mv $HOME/bin/btp* /usr/local/bin/

COPY --chmod=+x entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
