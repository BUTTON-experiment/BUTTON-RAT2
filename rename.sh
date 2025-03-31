#!/bin/bash

lower='button'
upper='BUTTON'
mixed='Button'

if [ ! -z $1 ]
then
  basestring=${1,,}
  upstring=${basestring^^}
  mixedstring=${basestring^}
  
  if [[ "$lower" == "button" ]] && [[ "$upper" == "BUTTON" ]] && [[ "$mixed" == "Button" ]];
  then
          echo -e "\n It appears you have already run this script. There is no need to run it again. \n"
          exit
  fi

  echo -e "\n Changing $lower, $upper, and $mixed to $basestring, $upstring, and $mixedstring."
  echo -e "\n DO NOT RUN THIS SCRIPT MORE THAN ONCE! \n"

  find . -type f -not -path "./.git/*" -exec sed -i "s/${lower}/${basestring}/g" {} \;
  find . -type f -not -path "./.git/*" -exec sed -i "s/${upper}/${upstring}/g" {} \;
  find . -type f -not -path "./.git/*" -exec sed -i "s/${mixed}/${mixedstring}/g" {} \;
  mv config/${lower}.sh.in config/${basestring}.sh.in
  mv src/${lower}.cpp src/${basestring}.cpp
  mv src/${mixed}.cc src/${mixedstring}.cc
  mv src/include/${mixed}.hh src/include/${mixedstring}.hh
fi
