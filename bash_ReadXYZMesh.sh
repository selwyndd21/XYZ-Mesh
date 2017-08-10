#!/bin/sh
# Variable Preservation:
#
#



###############################################################################
# Option definition
###############################################################################

####################
# ERROR code: no any parameters
####################
if [ $# -eq 0 ]; then
  echo "ERROR: No parameters nor inputs. Noting should be done!"
  exit 2
fi

########################################
# Input information
########################################
inpfile=$*
if [[ -z "$inpfile" ]]; then
  echo "ERROR: no input file disignated"
  exit 2
fi
echo "Input file: $inpfile"


################################################################################
# Main program
################################################################################
inpdata=(${inpfile// / })
length=${#inpdata[@]}
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# main for loop
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
for (( inputcount=0; inputcount<$length; inputcount++ )) ; do
  inputfile=${inpdata[$inputcount]}
  # set output files name from input file
  filename=$(basename "$inputfile")
  case=${filename%\.*}

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Read Title position
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  head -n 1 $filename > temp_title
  sed -i "s/[=\"Time]//g" temp_title
  ##########
  # WARNING code: remove esisting group data file
  if [[ -f "temp_location" ]]; then
    rm temp_location
  fi

  numc=$(( $(head -n 1 temp_title | grep -o ',' | wc -l) +1 ))
  for ((i=1; i<="$numc"; i++)) ; do 
    cut -d ','  -f "$i" temp_title | paste -s -d ',' >> temp_location
    echo "extract $i location"
  done 
  sed -i "s/-/ /g" temp_location
  sed -i "/^$/d" temp_location
  mv temp_location temp_title
  numc=$(( $(head -n 1 temp_title | grep -o ' ' | wc -l) +1 ))
  for ((i=1; i<="$numc"; i++)) ; do 
    cut -d ' '  -f "$i" temp_title | paste -s -d ' ' >> temp_location
    echo "transpose $i location"
  done 
  echo "end extracting locations"
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
# Read Title position
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Extract temperature data
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  cut -d ',' -f "2-" $filename > temp_temperature
  tail -n +2 temp_temperature > temp_data
  sed -i "s/,/ /g" temp_data
  cat temp_location temp_data > temp_temperature
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
# Extract temperature data
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Mapping XYZ-mesh 
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  inp1=temp_temperature
  out1=output_
  Xsize=14
  Ysize=14
  python Adding.py $inp1 $out1 $Xsize $Ysize
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
# Mapping XYZ-mesh 
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
done
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
# Main For loop
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

exit
