#!/bin/bash
function CheckRemoteExport(){
    # 1: Server, 2: Shared resource
    showmount -e $(cut -d: -f1 <<< $@) \
        | grep -Ei "$(cut -d: -f2 <<< $@)"
}

while IFS= read -r MountLine; do
    # 3: Local mount point
    MountPoint=$(cut -d: -f3 <<< ${MountLine})
    { mountpoint -q ${MountPoint} ;
        } && { CheckRemoteExport ${MountLine}  &> /dev/null \
            || umount -l -f ${MountPoint} ;
        } || { CheckRemoteExport ${MountLine} &> /dev/null \
            && mount ${MountPoint} ; }
done < <(grep -Ei '^[^.*#]+.*\bnfs\b.*' /etc/fstab \
            | awk '{print $1 ":" $2}')
