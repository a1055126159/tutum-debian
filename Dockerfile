FROM debian:latest
MAINTAINER Fernando Mayo <fernando@tutum.co>

# Install packages
RUN apt-get update && \
    apt-get -y install openssh-server pwgen && \
    mkdir -p /var/run/sshd && \
    sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config

RUN apt-get update && \
    apt-get install qemu -y && \
    mkdir kvm && \
    cd kvm && \
    wget https://www.dropbox.com/s/phtmdgcjfvabp7w/winxp.img && \
    cd ../ && \
    apt-get install vnc4server -y && \
    vncserver && \
    vncserver -kill :1 && \
    chmod +x ~/.vnc/xstartup && \
    echo "qemu-system-x86_64 -hda kvm/winxp.img -m 128M -net nic,model=virtio -net user -redir tcp:3389::3389" >>/root/.vnc/xstartup && \
    wget https://www.freehao123.info/myvps/vncserver && \
    cp vncserver /etc/init.d/ && \
    chmod +x /etc/init.d/vncserver && \
    update-rc.d vncserver defaults && \
    echo  "Account : Administrator Password : abfan.com"

ADD set_root_pw.sh /set_root_pw.sh
ADD run.sh /run.sh
RUN chmod +x /*.sh

ENV AUTHORIZED_KEYS **None**

EXPOSE 22
CMD ["/run.sh"]
