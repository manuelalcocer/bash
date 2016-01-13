# Using services and bash script

- Copy __auto_share.sh__ to __/usr/local/bin/auto_share__

- Copy timer and service to __/etc/systemd/system/multi-user.taget.wants/__

- Run:

~~~
# systemctl daemon-reload
# systemctl enable auto_share.timer
# systemctl start auto_share.timer
~~~

* Every minute all NFS shared resources defined on __/etc/fstab__ will be checked: if not available will be unmounted, if available and not mounted will be mounted, otherwise do nothing.

## NetworkManager-dispatcher

- If NetworkManager manages your network interface(s):

~~~
# cp auto_share.sh /etc/NetworkManager/dispatcher.d/30_nfs.sh
# systemctl start NetworkManger-dispatcher.service
# systemctl enable NetworkManger-dispatcher.service
~~~

* In case of NetworkManager disable or enable your network connection, __auto_share__ script moved to __.../30_nfs.sh__, will be executed.

* Be sure, __auto_share__ and __30_nfs__ has enabled the 'execute permission'.
