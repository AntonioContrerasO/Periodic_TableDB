#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $1 ]]
then
  if [[  $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
  else
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' OR name='$1'")
  fi

  if [[ -z $ATOMIC_NUMBER ]]
  then
  echo I could not find that element in the database.
  else
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
  TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER;")
  A_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  MELT_P=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  BOIL_P=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  echo "The element with atomic number $(echo $ATOMIC_NUMBER | sed -r 's/^ *| *$//g') is $(echo $NAME | sed -r 's/^ *| *$//g') ($(echo $SYMBOL | sed -r 's/^ *| *$//g')). It's a $(echo $TYPE | sed -r 's/^ *| *$//g'), with a mass of $(echo $A_MASS | sed -r 's/^ *| *$//g') amu. $(echo $NAME | sed -r 's/^ *| *$//g') has a melting point of $(echo $MELT_P | sed -r 's/^ *| *$//g') celsius and a boiling point of $(echo $BOIL_P| sed -r 's/^ *| *$//g') celsius."
  fi

else
  echo "Please provide an element as an argument."
fi
