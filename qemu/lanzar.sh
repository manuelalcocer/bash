#!/usr/bin/env bash

# Uso del script:
# lanzar archivo.qcow2 interfaz_0 interfaz_1 interfaz_2 ..... interfaz_n

# captura los parámetros y los mete en un vector
parametros=("$@")

# si solo se pone un parámetro, sale
(( ${#parametros[@]} < 2 )) && {
    echo 'Se necesitan al menos 2 parámetros: $ lanzar archivo.qcow2 interfaz_de_red' ;
    exit 1 ;
}

# si el archivo no acaba en .qcow2, sale (comentar las siguientes 5 líneas si no se quiere esa comprobación)
extension=${parametros[0]##*.}
[[ "${extension}" = 'qcow2' ]] || {
    echo 'el archivo ha de ser .qcow2' ;
    exit 1 ;
}

# Si no existe el archivo, sale.
[[ -f "${parametros[0]}" ]] || {
    echo "No existe el archivo: ${parametros[0]}" ;
    exit 1 ;
}

# archivo de disco
archivo_disco=${parametros[0]}

### Creación del comando a ejecutar, modificar al gusto
###
# comando de kvm (cambiar según se use kvm, qemu 32 bits o qemu64 bits)
comando='qemu-system-x86_64'
# parámetro de disco (modificar si es necesario)
diskparam="-drive file=${archivo_disco},format=qcow2"
# lista de parámetros adicionales a pasar al comando
comadpar=('-enable-kvm' '-m 1G' '-boot c')

comando_completo="${comando} ${diskparam} ${comadpar}"

# Creación del comando completo
for x in $(seq 0 $((${#parametros[@]} - 2))); do
    MAC=$(echo '02:'$(openssl rand -hex 5 | sed 's/\(..\)/\1:/g; s/.$//'))
    interfaz=${parametros[(($x+1))]}
    parametro_red="-net nic,macaddr=${MAC},model=virtio,netdev=n${x} \
        -netdev tap,id=n${x},ifname=${interfaz},script=no,downscript=no,vhost=on"
    comando_completo="${comando_completo} ${parametro_red}"    
done

# ejecución del comando completo
$comando_completo

