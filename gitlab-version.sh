#!/bin/bash

#Token Privado
PT="tu-token-privado"

#Link a la API de GitLab
LG="https://example.com/api/v4/version"

#Link a la API de Docker
LD="https://registry.hub.docker.com/v2/repositories/gitlab/gitlab-ee/tags/"

#Para GitLab community edition:
#LD="https://registry.hub.docker.com/v2/repositories/gitlab/gitlab-ce/tags/"

#Versión Actual
VA=$(curl -s --header "PRIVATE-TOKEN: $PT" $LG | cut -d',' -f1 | cut -d'"' -f4)

#Últimas versiones
UV=$(curl -s $LD | jq -r '.results[] | .name' | sort -V -r | head -7 | tail -4)

clear

echo -e "\nVersión actual del GitLab CDD:\n$VA\n"
sleep 1

echo -e "Últimas versiones:\n$UV\n"
sleep 1

#Obtenemos la última versión
VN=$(echo $UV | cut -d' ' -f1)

echo -e "Última versión disponible:\n$VN\n"
sleep 1

#Limpiamos los números de las versiones y las guardamos en variables según el nivel
A1=$(echo $VA | cut -d'.' -f1)
A2=$(echo $VA | cut -d'.' -f2)
A3=$(echo $VA | cut -d'.' -f3 | cut -d'-' -f1)

N1=$(echo $VN | cut -d'.' -f1)
N2=$(echo $VN | cut -d'.' -f2)
N3=$(echo $VN | cut -d'.' -f3 | cut -d'-' -f1)

#Depuramos y averiguamos haciendo calculos, a que nivel debemos actualizar el GitLab
if [ "$N1" -eq "$A1" ]
then
	echo "GitLab está actualizado a su última versión"

#Primer nivel
elif [ "$N1" -gt "$A1" ]
then
	echo -e "Has de actualizar a primer nivel:\nDe $VA a $VN"

	#Segundo nivel
	if [ "$N2" -gt "$A2" ]
	then
		R2=$(($N2 - $A2))
		echo -e "Saltos de segundo nivel: $R2\n"

		if [ "$R2" -gt 1 ]
		then
			echo -e "$VA necesita dar $R2 saltos a nivel 2 para actualizar a $VN\n"
		fi

		if [ "$R2" -eq 1 ]
		then
			echo -e "$VA necesita dar un salto a nivel 2 para actualizar a $VN\n"
		fi
	fi

	#Tercer nivel
	if [ "$N3" -gt "$A3" ]
	then
		R3=$(($N3 - $A3))
		echo -e "Saltos de tercer nivel: $R3\n"

		if [ "$R3" -gt 1 ]
		then
			echo -e "$VA necesita dar $R3 saltos a nivel 3 para actualizar a $VN\n"
		fi

		if [ "$R3" -eq 1 ]
		then
			echo -e "$VA necesita dar un salto a nivel 3 para actualizar a $VN\n"
		fi
	fi
fi
