# Script que calcula la velocidad media de transferencia de red

#!/usr/bin/env bash
# 
# Cáculo aproximado de la velocidad de bajada y subida de la red
# TODO:
#   - Como interfaz poner un array con las interfaces de red
#   - Como valores crear un diccionario con las velocidades de las interfaces de red


function Velocidad(){
    
    # Variables:

    interfaz='enp4s0'
    # precision = tiempo que se están capturando valores para calcular el promedio
    precision='0.2'
    
    
    t1=$(cat /sys/class/net/${interfaz}/statistics/rx_bytes)
    sleep ${precision}
    t2=$(cat /sys/class/net/${interfaz}/statistics/rx_bytes)
    descargado=$((t2-t1))
    # vdownload = bytes por segundo
    vdownload=$(echo ${descargado}/${precision} | bc -l)
    if (( ${vdownload%.*} > 1000 && ${vdownload%.*} < 1000000 )); then
        VDESCARGA=$(echo ${vdownload} / 1000 | bc -l | grep -Eo '[0-9]*\.[0-9]{0,2}')
    elif (( ${vdownload%.*} > 1000000 )); then
        VDESCARGA=$(echo ${vdownload} / 1000000 | bc -l | grep -Eo '[0-9]*\.[0-9]{0,2}')
    else
        VDESCARGA=${vdownload%.*}
    fi
    t1=$(cat /sys/class/net/${interfaz}/statistics/tx_bytes)
    sleep ${precision}
    t2=$(cat /sys/class/net/${interfaz}/statistics/tx_bytes)
    subido=$((t2-t1))
    # vupload = bytes por segundo
    vupload=$(echo ${subido}/${precision} | bc -l)
    if (( ${vupload%.*} > 1000 && ${vupload%.*} < 1000000 )); then
        VSUBIDA=$(echo ${vupload} / 1000 | bc -l | grep -Eo '[0-9]*\.[0-9]{0,2}')
    elif (( ${vupload%.*} > 1000000 )); then
        VSUBIDA=$(echo ${vupload} / 1000000 | bc -l | grep -Eo '[0-9]*\.[0-9]{0,2}')
    else
        VSUBIDA=${vupload%.*}
    fi
}

tmuestra=2
while true; do
    Velocidad
    sleep ${tmuestra}
done
