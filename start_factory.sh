#!/bin/bash

/usr/sbin/sshd
/usr/sbin/cron

su - steam -c '/satisfactory/FactoryServer.sh'
