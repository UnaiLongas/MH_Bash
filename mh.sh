#!/bin/bash

### Valores iniciales ###
intentos=14;
dif=2;
DIALOG_CANCEL=1;
DIALOG_ESC=255;
HEIGHT=0;
WIDTH=0;
debug=0;
player="";
#


### Antes de empezar ###
function reset(){
    #resetear intentos
    rm ./src/intentos.txt
    touch ./src/intentos.txt
    #resetear numeros probados
    for ((i=0;i<numsTriedCnt;i++))
    do
        numsTried["$i"]="";
    done
    numsTriedCnt=0;
    # echo -e "Player\t Level\t Tries\t Number \n" > ./src/ranking.txt;
    # { cat _rank_dif.txt;cat _rank_mid.txt;cat _rank_eas.txt; } >> ./src/ranking.txt;
    #  >> ./src/ranking.txt;
    #  >> ./src/ranking.txt;
    };
#


### Funciones ###
# Menu #
function menu_principal (){
    reset;
  
  exec 3>&1
  selection=$(dialog \
    --backtitle "Muertos y Heridos" \
    --title "Menú" \
    --clear \
    --cancel-label "Salir" \
    --menu "Please select:" $HEIGHT $WIDTH 7 \
    "1" "Jugar - Facil" \
    "2" "Jugar - Intermedio" \
    "3" "Jugar - Dificil" \
    "4" "Seleccionar nombre" \
    "5" "Ranking" \
    "6" "Act/Des debug" \
    "7" "Salir" \
    2>&1 1>&3)

  exit_status=$?
  exec 3>&-

  case $exit_status in
    "$DIALOG_CANCEL")
      clear
      echo "Program terminated."
      exit
      ;;
    "$DIALOG_ESC")
      clear
      echo "Program aborted." >&2
      exit 1
      ;;
  esac;
  
  opcion_del_menu;}

# Menu - opciones #
function opcion_del_menu (){
  case $selection in
    0 )
      clear
      echo "Programa terminado."
      ;;
    1 )
	    dif=1;
        intentos=14;
        set_num;
      ;;
    2 )
	    dif=2;
        intentos=14;
        set_num;
      ;;
    3 )
        dif=3;
        intentos=14;
        set_num;
      ;;
    4 )
        exec 3>&1;
        player=$(dialog --inputbox "Introduzca nombre del jugador \n(8 digitos max.)" 0 0 2>&1 1>&3);
        exec 3>&-;
        while [[ ${#player} -gt 8 ]];do
            exec 3>&1;
            player=$(dialog --inputbox "Introduzca nombre del jugador \n(8 digitos max.)" 0 0 2>&1 1>&3);
            exec 3>&-;
        done
        menu_principal;
      ;;
    5 )
        #tmpRank=$(cat ./src/ranking.txt);
	    dialog --title "Ranking" --textbox ./src/ranking.txt 20 50
        menu_principal;
      ;;
    6 )
	    debug
      ;;
    7 )
        exit;
      ;;
  esac;}


# Debug #
function debug(){
    if [[ debug -eq 0 ]];then 
        debug=1;
        dialog --infobox "Modo debug activado" 0 0; sleep 2;
    else 
        debug=0;
        dialog --infobox "Modo debug desactivado" 0 0; sleep 2;
    fi
    menu_principal;}
# Numero - Set #
function set_num(){
    if [[ dif -eq 1 ]];then 
        num[0]=11;num[1]=11;num[2]=11;

        for i in 0 1 2
        do
            tmp=$((RANDOM%9));
            while [[ $tmp -eq ${num[0]} ]] || [[ $tmp -eq ${num[1]} ]] || [[ $tmp -eq ${num[2]} ]];
            do
                tmp=$((RANDOM%9));
            done
            num[$i]=$tmp;
        done
    elif [[ dif -eq 2 ]];then 
        num[0]=11;num[1]=11;num[2]=11;num[3]=11;

        for i in 0 1 2 3
        do
            tmp=$((RANDOM%9));
            while [[ $tmp -eq ${num[0]} ]] || [[ $tmp -eq ${num[1]} ]] || [[ $tmp -eq ${num[2]} ]] || [[ $tmp -eq ${num[3]} ]];
            do
                tmp=$((RANDOM%9));
            done
            num[$i]=$tmp;
        done
    else
        num[0]=11;num[1]=11;num[2]=11;num[3]=11;num[4]=11;

        for i in 0 1 2 3 4
        do
            tmp=$((RANDOM%9));
            while [[ $tmp -eq ${num[0]} ]] || [[ $tmp -eq ${num[1]} ]] || [[ $tmp -eq ${num[2]} ]] || [[ $tmp -eq ${num[3]} ]] || [[ $tmp -eq ${num[4]} ]];
            do
                tmp=$((RANDOM%9));
            done
            num[$i]=$tmp;
        done
    fi;

    intento;};
# Resultado - Loose #
function res_los(){
    txtLos=$(cat ./src/los.txt);
    if [[ dif -eq 1 ]];then 
        txtLos="${txtLos}\n\nEl número era: ${num[0]}${num[1]}${num[2]}"
    elif [[ dif -eq 2 ]];then 
        txtLos="${txtLos}\n\nEl número era: ${num[0]}${num[1]}${num[2]}${num[3]}"
    else
        txtLos="${txtLos}\n\nEl número era: ${num[0]}${num[1]}${num[2]}${num[3]}${num[4]}"
    fi;
    dialog --infobox "${txtLos}" 0 0; sleep 4;
    menu_principal;};

# Resultado - Win #
function res_win(){
    txtWin=$(cat ./src/win.txt);
    if [[ dif -eq 1 ]];then 
        txtWin="${txtWin}\n\nEl número era: ${num[0]}${num[1]}${num[2]}"
        tmpIntentos=$(( 14 - intentos + 1 ))
        echo -e "$player\t    Easy     $tmpIntentos tries   ${num[0]}${num[1]}${num[2]}" >> ./src/ranking.txt;
    elif [[ dif -eq 2 ]];then 
        txtWin="${txtWin}\n\nEl número era: ${num[0]}${num[1]}${num[2]}${num[3]}"
        tmpIntentos=$(( 14 - intentos + 1 ))
        echo -e "$player\t    Medium   $tmpIntentos tries   ${num[0]}${num[1]}${num[2]}${num[3]}" >> ./src/ranking.txt;
    else
        txtWin="${txtWin}\n\nEl número era: ${num[0]}${num[1]}${num[2]}${num[3]}${num[4]}"
        tmpIntentos=$(( 14 - intentos + 1 ))
        echo -e "$player\t    Hard     $tmpIntentos tries   ${num[0]}${num[1]}${num[2]}${num[3]}${num[4]}" >> ./src/ranking.txt;
    fi;
    dialog --infobox "${txtWin}" 0 0; sleep 4;
    menu_principal;};

# Resultado - Retry #
    #function res_ret(){
    #    txt=$(cat ./src/intentos.txt);
    #    dialog --title "Título" --msgbox "${txt}" 0 0;
    #    intento;};
# Intento - Check result #
function chkRes(){
    muertos=0;
    heridos=0;
    
    cnt_i=0;
    for i in "${num_try[@]}";       #Recorre los numeros del intento
    do
        cnt_j=0
        for j in "${num[@]}";       #Recorre los numero a acertar
        do
            if [[ $i -eq $j ]] && [[ $cnt_i -eq $cnt_j ]];then ((muertos++));   #Si las pos y nums son iguales => M
            elif [[ $i -eq $j ]];then ((heridos++));                            #Si solo el numero es igual => H
            fi;
            ((cnt_j++));
        done;
        ((cnt_i++));
    done;

    if [[ dif -eq 1 ]];then 
        echo -e "Numero: ${num_try[0]}${num_try[1]}${num_try[2]} => M:$muertos H:$heridos\\\n" >> ./src/intentos.txt;
        if [[ $muertos -ne 3 ]];then ((intentos--));else res_win;fi;
        if [[ $intentos -eq 0 ]];then res_los;else intento;fi;
    elif [[ dif -eq 2 ]];then 
        echo -e "Numero: ${num_try[0]}${num_try[1]}${num_try[2]}${num_try[3]} => M:$muertos H:$heridos\\\n" >> ./src/intentos.txt;
        if [[ $muertos -ne 4 ]];then ((intentos--));else res_win;fi;
        if [[ $intentos -eq 0 ]];then res_los;else intento;fi;
    else
        echo -e "Numero: ${num_try[0]}${num_try[1]}${num_try[2]}${num_try[3]}${num_try[4]} => M:$muertos H:$heridos\\\n" >> ./src/intentos.txt;
        if [[ $muertos -ne 5 ]];then ((intentos--));else res_win;fi;
        if [[ $intentos -eq 0 ]];then res_los;else intento;fi;
    fi;};

# Intento #
function intento(){
    txt=$(cat ./src/intentos.txt);
    txt="Intentos_________________\n${txt}_________________________\n\n"
    exec 3>&1;

    if [[ dif -eq 1 ]];then 
        if [[ $debug -eq 0 ]];then result=$(dialog --inputbox "$txt$intentos intento(s)" 0 0 2>&1 1>&3);
        else result=$(dialog --inputbox "$txt$intentos intento(s) \nResultado:${num[0]}${num[1]}${num[2]}" 0 0 2>&1 1>&3);fi
        cntNums=3;
    elif [[ dif -eq 2 ]];then 
        if [[ $debug -eq 0 ]];then result=$(dialog --inputbox "$txt$intentos intento(s)" 0 0 2>&1 1>&3);
        else result=$(dialog --inputbox "$txt$intentos intento(s) \nResultado:${num[0]}${num[1]}${num[2]}${num[3]}" 0 0 2>&1 1>&3);fi
        cntNums=4;
    else
        if [[ $debug -eq 0 ]];then result=$(dialog --inputbox "$txt$intentos intento(s)" 0 0 2>&1 1>&3);
        else result=$(dialog --inputbox "$txt$intentos intento(s) \nResultado:${num[0]}${num[1]}${num[2]}${num[3]}${num[4]}" 0 0 2>&1 1>&3);fi
        cntNums=5;
    fi;

    exec 3>&-;
    #echo "$result";
    len=${#result};
    if [[ $len -ne $cntNums ]];then    #Comprobar que introduce 4 digitos
        dialog --infobox "introduce $cntNums digitos" 0 0; sleep 1;
        intento;
    else
        if [[ ! "$result" =~ ^[0-9]+$ ]];   #Comprobar que introduce numeros y no letras
        then
            dialog --infobox "Introduce numeros" 0 0; sleep 1;
            intento;
        else            

            for ((i=0;i<cntNums;i++))
            do
                local num_try["$i"]=${result:i:1};
            done
            #local num_try[0]=${result:0:1};
            #local num_try[1]=${result:1:1};
            #local num_try[2]=${result:2:1};
            #local num_try[3]=${result:3:1};
            
            cnt=0;
            for i in "${num_try[@]}"
            do
                for ((x=0;x<cntNums;x++))
                do
                    if [[ $i -eq ${num_try[x]} ]];then ((cnt++)); fi;
                done
                #if [[ $i -eq ${num_try[0]} ]];then ((cnt++)); fi;
                #if [[ $i -eq ${num_try[1]} ]];then ((cnt++)); fi;
                #if [[ $i -eq ${num_try[2]} ]];then ((cnt++)); fi;
                #if [[ $i -eq ${num_try[3]} ]];then ((cnt++)); fi;
            done;

            #echo "$cnt";
            if [[ $cnt -ne $cntNums ]];then        #Numeros unicos
                dialog --infobox "No se pueden repetir digitos" 0 0; sleep 1;
                intento;
            else 

                if [[ dif -eq 1 ]];then 
                    numTryStr="${num_try[0]}${num_try[1]}${num_try[2]}";
                elif [[ dif -eq 2 ]];then 
                    numTryStr="${num_try[0]}${num_try[1]}${num_try[2]}${num_try[3]}";
                else
                    numTryStr="${num_try[0]}${num_try[1]}${num_try[2]}${num_try[3]}${num_try[4]}";
                fi;

                chkTriedNum=0;
                for (( i=0;i <= numsTriedCnt ;i++ ))
                do
                    if  [[ ${numsTried[$i]} = "$numTryStr" ]];then 
                        chkTriedNum=1;
                    fi
                done

                if [[ chkTriedNum -eq 1 ]];then     #Comprobar si se ha intentado el numero
                    dialog --infobox "Ya has probado este numero" 0 0; sleep 1;
                    intento;
                else
                    numsTried[${numsTriedCnt}]="$numTryStr";
                    ((numsTriedCnt++));
                    chkRes;
                fi
            fi;    

        fi;
    fi;};
#


### Ejecucion ###
menu_principal
#