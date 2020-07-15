#cloud-config

users:
- name: cloudservice
  uid: 2000

write_files:
- path: /etc/systemd/system/myservice.service
  permissions: 0644
  owner: root
  content: |
    [Unit]
    Description=Minecraft Server
    Requires=docker.service network-online.target
    After=docker.service network-online.target
    [Service]
    Environment="HOME=/home/cloudservice"
    ExecStart=/usr/bin/docker -p 80:25565 -e VERSION=${version} --name mc itzg/minecraft-server
    ExecStop=/usr/bin/docker stop myservice
    Restart=on-failure
    RestartSec=10
    [Install]
    WantedBy=multi-user.target

runcmd:
- iptables -A INPUT -p tcp -j ACCEPT
- systemctl daemon-reload
- systemctl enable --now --no-block myservice.service