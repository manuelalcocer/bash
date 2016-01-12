# Uso de los servicios y del script

- Copiar __auto_share.sh__ a __/usr/local/bin/auto_share__.

- Copiar el temporizador y el servicio a __/etc/systemd/system/multi-user.taget.wants/__

- Ejecutar:

~~~
# systemctl daemon-reload
# systemctl enable auto_share.timer
# systemctl start auto_share.timer
~~~

* Con esto se consigue que cada minuto se comprueben los recursos compartidos de NFS, en caso de no estar disponibles, los desmonta evitando un cuelgue molesto, sobre todo si se usa la opción de montaje 'hardlink'.

## NetworkManger-dispatcher

- Si NetworkManager gestiona la interfaz de red:

~~~
# cp auto_share /etc/NetworkManager/dispatcher.d/30_nfs.sh
~~~

* Con esto se consigue que al conectarse o conectarse de la red local, se comprueban los recursos y se actúa en consecuencia.

