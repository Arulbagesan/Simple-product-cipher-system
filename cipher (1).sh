#!/bin/bash
###Get User response for required action

function UserInput {
        echo "Enter keyword"
        read KEYWORD
        echo "Enter File Name"
        read FILE
        echo "$FILE will be $ACTIONSTRING using $KEYWORD"
}
function NewAlphabet {
        for (( i =0;i<${#KEYWORDARRAY[@]};i++ ))
        do
                for (( j=0;j<$i;j++ ))
                do
                        if [ ${KEYWORDARRAY[i]} == ${KEYWORDARRAY[j]} ]
                        then
                                NEWCHAR=0
                                break;
                        fi
                done
                if [ $NEWCHAR -eq 1 ]
                then
                        NEWALPHABET+=(${KEYWORDARRAY[i]})
                        position=$(printf "%d" \'${KEYWORDARRAY[i]})
                        ALPHABET[$(($position-65))]='0'
                fi
                NEWCHAR=1
        done
        for (( i =0;i<26;i++ ))
        do
                if [ ${ALPHABET[i]} != '0' ]
                then
                        NEWALPHABET+=(${ALPHABET[i]})
                fi
        done
        echo ${NEWALPHABET[@]}
}

function DecipherAlphabet {
        for (( i =0;i<${#KEYWORDARRAY[@]};i++ ))
        do
                for (( j=0;j<$i;j++ ))
                do
                        if [ ${KEYWORDARRAY[i]} == ${KEYWORDARRAY[j]} ]
                        then
                                NEWCHAR=0
                                break;
                        fi
                done
                if [ $NEWCHAR -eq 1 ]
                then
                        NEWALPHABET+=(${KEYWORDARRAY[i]})
                        position=$(printf "%d" \'${KEYWORDARRAY[i]})
                        ALPHABET[$(($position-65))]='0'
                fi
                NEWCHAR=1
        done
        for (( i =0;i<26;i++ ))
        do
                if [ ${ALPHABET[i]} != '0' ]
                then
                        NEWALPHABET+=(${ALPHABET[i]})
                fi
        done
        for (( i =0;i<26;i++ ))
        do
                position=$(printf "%d" \'${NEWALPHABET[i]})
                DECIPHERALPHABET[$(($position-65))]=$(printf \\$(printf "%o" $((i+65))))
        done
        echo ${DECIPHERALPHABET[@]}
}
function NewRearAlphabet {
        for (( i =0;i<${#KEYWORDARRAY[@]};i++ ))
        do
                for (( j=0;j<$i;j++ ))
                do
                        if [ ${KEYWORDARRAY[i]} == ${KEYWORDARRAY[j]} ]
                        then
                                NEWCHAR=0
                                break;
                        fi
                done
                if [ $NEWCHAR -eq 1 ]
                then
                        UNIQUECHARS+=(${KEYWORDARRAY[i]})
                        position=$(printf "%d" \'${KEYWORDARRAY[i]})
                        ALPHABET[$(($position-65))]='0'
                fi
                NEWCHAR=1
        done
        for (( i=0;i<${#UNIQUECHARS[@]};i++ ))
        do
                REARALPHABET[26-${#UNIQUECHARS[@]}+i]=${UNIQUECHARS[i]}
        done
        REARCOUNTER=0
        for (( i =0;i<26;i++ ))
        do
                if [ ${ALPHABET[i]} != '0' ]
                then
                        REARALPHABET[$REARCOUNTER]=${ALPHABET[i]}
                        REARCOUNTER=$((REARCOUNTER+1))
                fi
        done
        echo ${REARALPHABET[@]}
}

ACTION=0
while [[ $ACTION -ne 1 && $ACTION -ne 2 && $ACTION -ne 3 && $ACTION -ne 4 ]]
do
        echo "What do you want to do? Enter 1,2,3 or 4"
        echo "   1.) Encrypt a File"
        echo "   2.) Decrypt a File"
        echo "   3.) Calculate Frequency"
        echo "   4.) Dual Encryption"
        read ACTION
done
if [ $ACTION -eq 1 ]
then
        ALPHABET=('A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O' 'P' 'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z')
        NEWALPHABET=()
        NEWCHAR=1
        KEYWORD=
        FILE=
        ACTIONSTRING="encrypted"
        UserInput KEYWORD FILE ACTIONSTRING
        KEYWORDARRAY=($(echo $KEYWORD | grep -o . | tr "a-z" "A-Z"))
        NewAlphabet ALPHABET NEWALPHABET NEWCHAR KEYWORDARRAY
#Processing File with ciphering alphabet#
########################################
        IFS=
        while read -r -N1 c; do
                if [[ $c == [A-Z] ]]
                then
                        GETPOSITION=$(printf "%d" \'$c)
                        printf "%c" ${NEWALPHABET[$(($GETPOSITION-65))]} >> "CIPHER"$FILE
                elif [[ $c == [a-z]  ]]
                then
                        GETPOSITION=$(printf "%d" \'$c)
                        printf "%c" ${NEWALPHABET[$(($GETPOSITION-97))]} >> "CIPHER"$FILE
                else
                        printf "%c" "$c" >> "CIPHER"$FILE
                fi
        done < $FILE
######End of Encryption #####
fi
if [ $ACTION -eq 2 ];then
        ALPHABET=('A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O' 'P' 'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z')
        DECIPHERALPHABET=(' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ')
        KEYWORD=
        FILE=
        ACTIONSTRING="decrypted"
        UserInput KEYWORD FILE ACTIONSTRING
        KEYWORDARRAY=($(echo $KEYWORD | grep -o . | tr "a-z" "A-Z"))
        #echo ${UNIQUE[@]}
        NEWALPHABET=()
        NEWCHAR=1
        DecipherAlphabet ALPHABET NEWALPHABET DECIPHERALPHABET KEYWORDARRAY NEWCHAR
###Processing File with ciphering alphabet#
        IFS=
        while read -r -N1 c; do
                if [[ $c == [A-Z] ]]
                then
                        GETPOSITION=$(printf "%d" \'$c)
                        printf "%c" ${DECIPHERALPHABET[$(($GETPOSITION-65))]} >> "DECIPHER"$FILE
                elif [[ $c == [a-z] ]]
                then
                        GETPOSITION=$(printf "%d" \'$c)
                        printf "%c" ${DECIPHERALPHABET[$(($GETPOSITION-97))]} >> "DECIPHER"$FILE
                else
                        printf "%c" "$c" >> "DECIPHER"$FILE
                fi
        done < $FILE
######End of decryption #####
fi
if [ $ACTION -eq 3 ];then
        FREQUENCY=(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
        echo "Enter File Name"
        read FILE
        IFS=
        while read -r -N1 c; do
                if [[ $c == [A-Z] ]]
                then
                        GETPOSITION=$(printf "%d" \'$c)
                        (( FREQUENCY[$(($GETPOSITION-65))]+=1 ))
                elif [[ $c == [a-z] ]]
                then
                        GETPOSITION=$(printf "%d" \'$c)
                        (( FREQUENCY[$(($GETPOSITION-97))]+=1 ))
                fi
        done < $FILE
        TOTALCHARACTERS=0;
        for (( i=0;i<26;i++ ))
        do
                TOTALCHARACTERS=$((${FREQUENCY[i]} + $TOTALCHARACTERS))
        done
        echo $TOTALCHARACTERS
        for (( i=0;i<26;i++ ))
        do
                FREQUENCYPERCENTAGE[i]=$(((${FREQUENCY[i]}*100)/$TOTALCHARACTERS))
        done
        echo ${FREQUENCYPERCENTAGE[@]}
        echo ${FREQUENCY[@]}
fi
if [ $ACTION -eq 4 ];then
        ALPHABET=('A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O' 'P' 'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z')
        NEWALPHABET=()
        NEWCHAR=1
### Get the keyword for encryption
        KEYWORD=
        FILE=
        ACTIONSTRING="dual encrypted"
        UserInput KEYWORD FILE ACTIONSTRING
        KEYWORDARRAY=($(echo $KEYWORD | grep -o . | tr "a-z" "A-Z"))
        NewAlphabet KEYWORDARRAY NEWALPHABET ALPHABET NEWCHAR
#Processing File with ciphering alphabet#
########################################
         IFS=
        while read -r -N1 c; do
                if [[ $c == [A-Z] ]]
                then
                        GETPOSITION=$(printf "%d" \'$c)
                        printf "%c" ${NEWALPHABET[$(($GETPOSITION-65))]} >> "CIPHER"$FILE
                elif [[ $c == [a-z] ]]
                then
                        GETPOSITION=$(printf "%d" \'$c)
                        printf "%c" ${NEWALPHABET[$(($GETPOSITION-97))]} >> "CIPHER"$FILE
                else
                        printf "%c" "$c" >> "CIPHER"$FILE
                fi
        done < $FILE
######End First round of Encryption #####
        ALPHABET=('A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O' 'P' 'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z')
        REARALPHABET=('A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O' 'P' 'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z')
        NEWCHAR=1
        REARCOUNTER=0
        UNIQUECHARS=()
        NewRearAlphabet ALPHABET REARALPHABET NEWCHAR REARCOUNTER UNIQUECHARS KEYWORDARRAY


#Processing File with ciphering alphabet#
########################################
        IFS=
        while read -r -N1 c; do
                if [[ $c == [A-Z] ]]
                then
                        GETPOSITION=$(printf "%d" \'$c)
                        printf "%c" ${REARALPHABET[$(($GETPOSITION-65))]} >> "DUALCIPHER"$FILE
                elif [[ $c == [a-z] ]]
                then
                        GETPOSITION=$(printf "%d" \'$c)
                        printf "%c" ${REARALPHABET[$(($GETPOSITION-97))]} >> "DUALCIPHER"$FILE
                else
                        printf "%c" "$c" >> "DUALCIPHER"$FILE
                fi
        done < "CIPHER"$FILE
        rm -rf "CIPHER"$FILE

fi
