#!/bin/sh

function patch_hosts() {
    # http://www.tothenew.com/blog/setting-up-sendmail-inside-your-docker-container/
    test $UID = "0" || return 1
    line=$(tail -n 1 /etc/hosts)
    line2=$(echo $line | awk '{print $2}')

    echo "$line $line2.localdomain" >>/etc/hosts
}

function start_sendmail() {
    echo Starting sendmail...
    # syslog and sendmail
    /etc/init.d/rsyslog start && /etc/init.d/sendmail start

}

function main() {
    if [[ "$1" == "" ]]; then
        patch_hosts || {
            echo "must be root "
            exit 1
        }
        start_sendmail || {
            echo "startup failed"
            exit 1
        }
        echo Started... tailing statistics...
        tail -f /var/log/maillog
    else
        $*
    fi
}

main $*
