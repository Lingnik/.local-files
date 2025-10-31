########################################################################################################################
echo "`/opt/homebrew/bin/gdate +%s%3N` whoami=`whoami` tty=`tty` pid=$$ ppid=$PPID cmd=${0##*/} file=${${(%):-%N}//$HOME/~}" >> /Users/tm/log/zsh.log
echo -n "DEBUG> ${${(%):-%N}//$HOME/~} >" && timing_ns=$(/opt/homebrew/bin/gdate +%s%3N)
echo -n "\t0 $((($(/opt/homebrew/bin/gdate +%s%3N) - timing_ns)))ms" && timing_ns=$(/opt/homebrew/bin/gdate +%s%3N)
export Z_LOADED=$((${Z_LOADED:-0} + 1)); export Z_LOADED_${Z_LOADED}=${(%):-%N}
########################################################################################################################

# This file should be empty

########################################################################################################################
echo "\tX $((($(/opt/homebrew/bin/gdate +%s%3N) - timing_ns)))ms >"
# DO NOT ADD MORE LINES
########################################################################################################################
