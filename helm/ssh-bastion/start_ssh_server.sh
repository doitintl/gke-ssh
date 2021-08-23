#!/bin/bash
if [ -n $USER ]; then
  for i in $(echo $USER | sed "s/,/ /g")
    do
      echo "INFO: Creating user $i";
      adduser -D -s /bin/bash $i;
      chmod -R 700 /home/$i/.ssh
      cat /keys/* >> /home/$i/.ssh/authorized_keys
      chown -R $i: /home/$i/.ssh
      chmod -R 700 /home/$i/.ssh/authorized_keys
  done
fi
exec /usr/sbin/sshd -D -e