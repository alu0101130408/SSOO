#!/bin/bash
#userProc.sh: Script que permite mostrar un listado con todos los usuarios que tienen al menos un proceso con un tiempo de CPU consumido mayor de N
#Autor: Joel Francisco Escobar Socas
#Asignatura: Sistemas Operativos
#####################################################################

#────────────────────────┤ Constantes ├──────────────────────────────
TITLE="BIENVIENIDO AL SCRIPT USERPROC"
FUNCTION="UserProc es un script que permite mostrar un listado con todos los usuarios que estan ejecutando proceso con un tiempo de cpu consumido especifico en la máquina $HOSTNAME"
AUTHOR="Joel Francisco Escobar Socas"
LINE="═══════════════════════════════════════════════════════════════"
#────────────────────────┤ Estilos ├──────────────────────────────
TEXT_BOLD=$(tput bold)
COLOR_GREEN=$TEXT_BOLD$(tput setaf 2)$TEXT_RESET
COLOR_MAGENTA=$TEXT_BOLD$(tput setaf 5)$TEXT_RESET
COLOR_CIAN=$TEXT_BOLD$(tput setaf 6)$TEXT_RESET
TEXT_RESET=$(tput sgr0)
TEXT_ULINE=$(tput sgr 0 1)
#────────────────────────┤ Variables ├──────────────────────────────

N="00:00:01"

opcion_help=0
opcion_t=0
opcion_usr=0
opcion_filter=0
opcion_inv=0
opcion_pid=0

#────────────────────────┤ Funciones ├──────────────────────────────
seconds_to_time()
{
  TIME="$auxN"
  echo | awk -v "S=$TIME" '{printf "%02d:%02d:%02d",S/(60*60),S%(60*60)/60,S%60}'
}

lista=$(ps -A -o user --no-headers|sort -u |uniq )
exist=$(cat /etc/passwd | tr -s ':' ' ' | cut -d ' ' -f1)
usrconect=$(who | tr -s ' ' ' '|cut -d ' ' -f1 )

cabecera(){
  echo "Autor: Joel Francisco Escobar Socas"
}

ProcessUsr(){
  cabecera
  echo "Función que muestra la lista de procesos de cpu "
  echo -e "$COLOR_CIAN$(ps -o user:20,uid,gid,cputime | head -n 1)\t PID_OLD_PROCESS\tNUM_PROCESS$TEXT_RESET"
  echo "$COLOR_MAGENTA────────────────────────────────────────────────────────────────────────────────────────────────────$TEXT_RESET"

  for i in $lista; do
    e_time=$(ps -u $i -o user,pid,gid,time --no-headers| sort -u | tr -s ' ' ' ' | cut -d ' ' -f4)
      for j in $e_time; do
        if [[ "$j">"$N" ]]; then 
          if [ "$opcion_usr" = "1" ]; then
            for k in $usrconect; do
              if [[ "$i" == "$k" ]]; then
                user_match="$i "
              fi
            done
          else
            user_match="$i " 
          fi
          #echo "Para el usuario $i -> $j es mayor que $N
        fi
      done

      for i in $user_match; do
        for j in $(ps -u $i -o pid --sort=cputime --no-headers|tail -n 1 | uniq);do
          aux=" " 
          if [[ "$j" > "$aux" ]]; then
            aux="$j "
          else
            aux="$aux "
          fi
          
          
        done
            
            username=$(ps -u $i -o user:20,uid,gid,pid,cputime:10 --sort=cputime --no-headers|tail -n 1 | uniq)
            pidold=$(ps -u $i -o pid --sort=cputime --no-headers|tail -n 1 | uniq)
            numproc=$(ps -u $i | wc -l|uniq )
            printf "${username}\t${pidold}\t\t\t${numproc}\n"
      done
       for i in $aux;do
        echo "el vector aux es: $i"
        done 
      
  done
       
        


}



#Función error_exit que controla la salida de errores
error_exit(){
  case $1 in
    1) echo "$TEXT_MAGENTA Error!: Opcion seleccionada no valida$TEXT_RESET" 1>&2
			help_func
			exit 1
			;;

    2) echo "$TEXT_MAGENTA Error!: Los argumentos introducidos son incompatibles$TEXT_RESET" 1>&2
      help_func
      exit 1
      ;;

    3) echo "$TEXT_MAGENTA Error!: Formato del número N no válido $TEXT_RESET" 1>&2
      format_case
      help_func
      exit 1
      ;;
    4) echo "$TEXT_MAGENTA Error!: opcion no encontrada $TEXT_RESET" 1>&2
      help_func
      exit 1
      ;;
    *) echo "$TEXT_MAGENTA Error Desconocido $TEXT_RESET" 1>&2
      help_func
      exit 1
      ;;
  esac

}

#Función que muestra el formato deseado 
format_case(){
  echo "El formato del número introducido debe ser: $TEXT_CIAN 00:00:00 $TEXT_RESET "
  echo "══════════════════════════════════════════════════════════════════════════════"
  echo "Donde: "
  echo "→ Los primeros $TEXT_CIAN 00:$TEXT_RESET corresponden a horas"
  echo "→ Los segundos $TEXT_CIAN :00:$TEXT_RESET corresponden a minutos"
  echo "→ Los terceros $TEXT_CIAN :00$TEXT_RESET corresponden a segundos"
  echo "→ Por defecto el valor será 00:00:01, correspondiente a 1 segundo"
  echo "══════════════════════════════════════════════════════════════════════════════"
}

#Función Help que muestra el uso del script

help_func(){

  echo "Modo de Uso: ./userProc.sh [Options] "
  echo "══════════════════════════════════════════════════════════════════════════════"
  echo "Las opciones soportadas son: "
  echo "→ Sin argumentos: Mostrará los usuarios que están ejecutando proceso con un tiempo de cpu consumido mayor que 00:00:01"
  echo "→ -h o --help: Mostrará una ayuda acerca del funcionamiento"
  echo "══════════════════════════════════════════════════════════════════════════════"

}



# #────────────────────────┤ Llamada al Main ├──────────────────────────────

clear
while [ "$1" != "" ]; do
  case $1 in
    --help | -h )
      echo " ─┤ Ayuda del Programa ├─"
      opcion_help=1	
      ;;

    -t )
      echo " Seleccionando el Número"
      opcion_t=1
      shift
      auxN=$1
      echo "auxN: $auxN"
      N=$(seconds_to_time)
      ;;

    -usr )
      echo "Filtrando por usuarios conectados a $HOSTNAME"
      opcion_usr=1
      ;;

    -u )
      echo "Filtrando por usuarios especificados"
      opcion_filter=1
      echo "lista usuarios: $lista"
      shift
      lista="$1 $2 $3 "
      
      echo "$usuario_parametro"
      ;;

    -inv )
      echo "Ordenando por INVERSA"
      opcion_inv=1
      lista=$(ps -A -o user --no-headers|sort -r |uniq)
      ;;

    -pid )
      echo "Ordenando por pid"
      opcion_pid=1
      ;;
    * )
      error_exit 1
      exit 4
      ;;

    esac
    shift
done

#────────────────────────┤ Gestión de las opciones pasadas por línea de comando ├──────────────────────────────
#Opcion por defecto (00)
if [ "$opcion_help" = "0" ] && [ "$opcion_t" = "0" ] ; then
ProcessUsr|uniq
# Si solo llamamos a ayuda (10)
elif [ "$opcion_help" = "1" ] && [ "$opcion_t" = "0" ]; then
help_func
# Si le pasamos el número de segundos a filtrar (01)
elif [ "$opcion_help" = "0" ] && [ "$opcion_t" = "1" ]; then
ProcessUsr |uniq
echo "N sera: $N"
elif [ "$opcion_usr" = "1" ] && [ "$opcion_t" = "0" ] && [ "$opcion_help" = "0" ]; then 
ProcessUsr |uniq
elif [ "$opcion_filter" = "1" ] && [ "$opcion_t" = "0" ] && [ "$opcion_help" = "0" ] && [ "$opcion_usr" = "0" ]; then 
ProcessUsr |uniq 
elif [ "$opcion_inv" = "1" ] && [ "$opcion_t" = "0" ] && [ "$opcion_help" = "0" ] && [ "$opcion_usr" = "0" ]; then 
ProcessUsr| uniq 
elif [ "$opcion_pid" = "1" ] && [ "$opcion_t" = "0" ] && [ "$opcion_help" = "0" ] && [ "$opcion_usr" = "0" ] && [ "$opcion_inv" = "0" ] && [  "$opcion_filter" = "0" ]; then 
ProcessUsr| sort -r |uniq
else
error_exit 2
fi

#────────────────────────┤ Fin del programa ├──────────────────────────────

exit 0