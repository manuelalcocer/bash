#!/bin/bash
while IFS= read -r montaje; do
    # 1: Servidor, 2: Recurso compartido, 3: Punto de montaje
    { mountpoint -q $(cut -d: -f3 <<< ${montaje}) ;
        } && { 
                { showmount -e $(cut -d: -f1 <<< ${montaje}) \
                    | grep -Ei "$(cut -d: -f2 <<< ${montaje})" ; 
                } &> /dev/null || umount -l -f $(cut -d: -f3 <<< ${montaje}) ; 
        } || {
                { showmount -e $(cut -d: -f1 <<< ${montaje}) \
                    | grep -Ei "$(cut -d: -f2 <<< ${montaje})" ;
                } &> /dev/null && mount $(cut -d: -f3 <<< ${montaje}) ; 
            }
done < <(grep -Ei '^[^.*#]+.*\bnfs\b.*' /etc/fstab | awk '{print $1 ":" $2}')
