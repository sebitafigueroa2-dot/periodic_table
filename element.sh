#!/bin/bash

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  ELEMENT=$(psql -U freecodecamp -d periodic_table -t -A -F "|" -c "SELECT elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE elements.atomic_number::VARCHAR = '$1' OR elements.symbol = '$1' OR elements.name = '$1';")

  if [[ -n $ELEMENT ]]
  then
    IFS="|" read -r NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< "$ELEMENT"

    echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  else
    echo "I could not find that element in the database."
  fi
fi
