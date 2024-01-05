#!/bin/bash

SERVICE_ACCOUNTS=("nobody" "www-data" "apache" "nginx" "mysql" "postgres" "redis" "mongodb" "tomcat" "ftp" "mail" "postfix" "exim" "dovecot" "squid" "nfsnobody" "rpc" "rpcuser" "rpcbind" "sshd" "couchdb" "rabbitmq" "memcached" "haproxy" "bind" "named" "sshd" "elasticsearch" "kibana" "logstash" "graylog" "amavis" "clamav" "git" "jenkins" "sonarqube" "cassandra" "neo4j" "samba" "snmp" "tftp" "winbind" "zabbix" "nagios" "gitlab-runner" "jenkins" "gitolite" "gitlab" "gitbucket" "redmine" "sonatype-nexus" "jenkins" "artifactory" "teamcity" "mattermost" "rocket.chat" "gitea" "openvpn" "strongswan" "wireguard" "openldap" "radius" "asterisk" "teamspeak" "mumble" "prosody" "ejabberd" "nfs" "rpcuser" "cyrus" "db2inst1" "db2fenc1" "informix" "ldap" "elasticsearch" "kibana" "logstash" "graylog" "amavis" "clamav" "git" "jenkins" "sonarqube" "cassandra" "neo4j" "samba" "snmp" "tftp" "winbind" "zabbix" "nagios" "gitlab-runner" "jenkins" "gitolite" "gitlab" "gitbucket" "redmine" "sonatype-nexus" "jenkins" "artifactory" "teamcity" "mattermost" "rocket.chat" "gitea" "openvpn" "strongswan" "wireguard" "openldap" "radius" "asterisk" "teamspeak" "mumble" "prosody" "ejabberd" "nfs" "rpcuser" "cyrus" "db2inst1" "db2fenc1" "informix" "ldap")

function evaluate() {
    for account in ${SERVICE_ACCOUNTS[@]}; do
        if [ -n "$(grep -E "^\s*$account\s*:\s*[^:]*:[0-9]*:[0-9]*:[^:]*:[^:]*:[^:]*$" /etc/passwd)" ]; then
            if [ -z "$(grep -E "^\s*$account\s*:\s*[^:]*:[0-9]*:[0-9]*:[^:]*:[^:]*:[^:]*$" /etc/passwd | grep -E ":\*" /etc/shadow)" ]; then
                exit 1
            fi
        fi
    done
  
}


function harden() {
    for account in ${SERVICE_ACCOUNTS[@]}; do
        if [ -n "$(grep -E "^\s*$account\s*:\s*[^:]*:[0-9]*:[0-9]*:[^:]*:[^:]*:[^:]*$" /etc/passwd)" ]; then
            if [ -z "$(grep -E "^\s*$account\s*:\s*[^:]*:[0-9]*:[0-9]*:[^:]*:[^:]*:[^:]*$" /etc/passwd | grep -E ":\*" /etc/shadow)" ]; then
                usermod -L $account
            fi
        fi
    done
    evaluate
    
}

if [ "$1" == "EV" ]; then
    evaluate
elif [ "$1" == "HA" ]; then
    harden
elif [ "$1" == "HELP" ]; then
    echo ""
else
    exit 1
fi
