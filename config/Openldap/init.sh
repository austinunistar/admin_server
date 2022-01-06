#!/usr/bin/bash

for i in `find /etc/openldap/schema -name *.ldif -print` ; do ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f ${i} ; done

cat > /etc/openldap/schema/1.db.ldif << EOF
dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcSuffix
olcSuffix: `echo ${LDAP_BASE_DN}`

dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcRootDN
olcRootDN: cn=`echo ${LDAP_ADMIN_ACCOUNT}`,`echo ${LDAP_BASE_DN}`

dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcRootPW
olcRootPW: `slappasswd -s ${LDAP_ADMIN_PASSWORD}`
EOF

ldapmodify -Y EXTERNAL  -H ldapi:/// -f /etc/openldap/schema/1.db.ldif

cat > /etc/openldap/schema/2.base.ldif << EOF
dn: `echo ${LDAP_BASE_DN}`
objectClass: domain
objectClass: top
dc: `echo ${LDAP_DOMAIN_DC}`
EOF

ldapadd -x -D "cn=`echo ${LDAP_ADMIN_ACCOUNT}`,`echo ${LDAP_BASE_DN}`" -f /etc/openldap/schema/2.base.ldif -w `echo ${LDAP_ADMIN_PASSWORD}`

cat > /etc/openldap/schema/3.access.ldif << EOF
dn: olcDatabase={1}monitor,cn=config
changetype: modify
replace: olcAccess
olcAccess: {0}to * by dn.base="gidNumber=0+uidNumber=0,cn=peercred,cn=external, cn=auth" read by dn.base="cn=`echo ${LDAP_ADMIN_ACCOUNT}`,`echo ${LDAP_BASE_DN}`" read by * none

changetype: modify
replace: olcAccess
olcAccess: {0}to dn.subtree="dc=itlab,dc=com" by dn.base="cn=`echo ${LDAP_ADMIN_ACCOUNT}`,`echo ${LDAP_BASE_DN}`" manage by * read
EOF

ldapmodify -Y EXTERNAL  -H ldapi:/// -f /etc/openldap/schema/3.access.ldif
