admin_server
============

# 內容說明

CONTAINER	|說明					| Port
------------|------------------------|-----
admin		| rpm package and ISO Image	| 80/tcp
cadvisor		| 監控 agent				| 9101/tcp
dns			| dns server				| 53/udp
grafana755	| Grafana Server			| 3000/tcp
openldap		| Openldap for test/dev/qa/sit	| 389/tcp
phpldapadmin	| Ldap admin Console		| 8080/tcp
phpmyadmin	| ITD 用					| 8081/tcp

## Install
- admin:<BR>
> 會使用 ./www 透過 nginx share 給 dev/qa/sit 環境的 package repo
- openldap:<BR>

> 需要初始化 LDAP BASE<BR>
>>啟動 container 後:<BR>

```bash
$ docker exec -it openldap systemctl start slapd
$ docker exec -it openldap bash /root/init.sh
```
