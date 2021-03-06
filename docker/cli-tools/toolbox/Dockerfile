ARG VERSION=latest
ARG FORGEOPS_REGISTRY=gcr.io/engineering-devops
FROM gcr.io/google-containers/pause:latest as pause

ARG VERSION=latest
ARG FORGEOPS_REGISTRY=gcr.io/engineering-devops
FROM $FORGEOPS_REGISTRY/yamkt:$VERSION-skaffold as finale
ARG COMMON_SCRIPT_SOURCE="https://raw.githubusercontent.com/microsoft/vscode-dev-containers/master/script-library/common-debian.sh"
ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

RUN adduser --disabled-password forgeops --no-create-home --home /opt/workspace --gid 0 \
        && mkdir -m 0770 -p /opt/{workspace,build} \
        && chown forgeops:root /opt/{workspace,build}
COPY --from=pause /pause /usr/local/bin/pause
# VScode prereqs from https://code.visualstudio.com/docs/remote/linux#_remote-host-container-wsl-linux-prerequisites
RUN apt-get update && apt-get install --yes vim jq curl dnsutils tmux git rsync openssh-server libc6 libstdc++6 \
        python-minimal ca-certificates tar

RUN mkdir -p /opt/build/.local/bin \
        && mkdir -p /opt/build/.vim/pack/plugins/start \
        && git clone --depth 1 https://github.com/dense-analysis/ale.git /opt/build/.vim/pack/plugins/start/ale \
        && git clone --depth 1 https://github.com/preservim/nerdtree.git /opt/build/.vim/pack/plugins/start/nerdtree \
                && mkdir -p /opt/build/etc/ssh \
                    && ssh-keygen -t rsa -f /opt/build/etc/ssh_host_rsa_key -N '' \
                        && cp /etc/ssh/sshd_config /opt/build/etc/sshd_config  \
                            && sed -i "s@UsePAM yes@UsePAM no@g" /opt/build/etc/sshd_config \
                                && sed -i "s@#HostKey /etc/ssh/ssh_host_rsa_key@HostKey /opt/workspace/etc/ssh_host_rsa_key@g" /opt/build/etc/sshd_config \
                                    && echo "AllowUsers forgeops" >> /opt/build/etc/sshd_config \
                                    && echo "PermitUserEnvironment yes" >> /opt/build/etc/sshd_config \
                                        && mkdir -p /opt/build/.ssh \
                                            && chmod -R 0700 /opt/build/.ssh \
                                                && chown -R forgeops:root /opt/

USER forgeops

RUN echo "PATH=/opt/workspace/bin:$PATH" >> /opt/build/.bashrc \
        && echo "bash -c /opt/build/bin/start-shell.sh" >> /opt/build/.bashrc

COPY --chown=forgeops:root etc /opt/build/etc
COPY --chown=forgeops:root bin/  /opt/build/bin
COPY --chown=forgeops:root bin/git-set-fork.sh /usr/local/bin

ENV SSH_PORT=4222
ENV WORKSPACE=/opt/workspace
WORKDIR /opt/workspace
ENTRYPOINT ["/opt/build/bin/entrypoint.sh"]
CMD ["/usr/local/bin/pause"]
