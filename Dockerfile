FROM node:16

WORKDIR /usr/src/app

COPY nodejs-application/package*.json ./

RUN npm install

COPY nodejs-application/ ./

RUN apt-get update && apt-get install -y openssh-server cron && \
    mkdir /var/run/sshd

RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

EXPOSE 22 3000

ENTRYPOINT service ssh start && cron && tail -f /dev/null

CMD ["node", "index.js"]
