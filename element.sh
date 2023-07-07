#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t -c"

MAIN()
{
  ELEMENT=$1

  if [[ -z $ELEMENT ]]
  then
    echo -e "Please provide an element as an argument."
    exit 0;
  fi

  # get element from db
  if [[ $ELEMENT =~ [0-9]+ ]]
  then
    ELEMENT_RESULT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p ON e.atomic_number = p.atomic_number JOIN types t ON t.type_id = p.type_id WHERE e.atomic_number = $ELEMENT")
  else
    ELEMENT_RESULT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p ON e.atomic_number = p.atomic_number JOIN types t ON t.type_id = p.type_id WHERE e.symbol = '$ELEMENT' OR e.name = '$ELEMENT'")
  fi

  if [[ -z $ELEMENT_RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    echo $ELEMENT_RESULT | while read ATOMIC_NUMBER BAR ATOMIC_NAME BAR ATOMIC_SYMBOL BAR M_TYPE BAR ATOMIC_MASS BAR ATOMIC_MP BAR ATOMIC_BP
    do
      NUMBER=$(echo $ATOMIC_NUMBER | sed -r 's/^ *| *$//g')
      NAME=$(echo $ATOMIC_NAME | sed -r 's/^ *| *$//g')
      SYMBOL=$(echo $ATOMIC_SYMBOL | sed -r 's/^ *| *$//g')
      TYPE=$(echo $M_TYPE | sed -r 's/^ *| *$//g')
      MASS=$(echo $ATOMIC_MASS | sed -r 's/^ *| *$//g')
      MP=$(echo $ATOMIC_MP | sed -r 's/^ *| *$//g')
      BP=$(echo $ATOMIC_BP | sed -r 's/^ *| *$//g')

      echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
    done
  fi
}

MAIN $1
exit 0;