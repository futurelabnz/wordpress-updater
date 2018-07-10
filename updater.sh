#!/bin/bash

#safely loading configuration file
typeset -A config
config=( # set default values in config array
    [rootfolder]="/var/www/"
    [clientemail]=""
)

#echo ${config[username]} # should be loaded from defaults
##end of load of configuration

for path in $(ls -d -1 ${config[rootfolder]}**)
do

  #firstly check whether there's configuration file and if theree is overwrite default values
  if [ -f "$path/updater.conf" ]; then
    while read line
    do
      if echo $line | grep -F = &>/dev/null
      then
          varname=$(echo "$line" | cut -d '=' -f 1)
          config[$varname]=$(echo "$line" | cut -d '=' -f 2-)
      fi
    done < "$path/updater.conf"
  fi

#echo $path;
  #this is test whether it's WP installation. It might not work if you have modifications to default filestructure
  #avoids running scripts on non-wp installations
  if [ -d "$path/htdocs/wp-includes" ]; then
    old_owner="$(ls -ld $path/htdocs | awk '{print $3}')"
    sudo chown -R ubuntu $path/htdocs
    echo "==============================="
    echo "Updating site $(basename $path)"
    echo "==============================="


    plugin_output="$(wp --path="$path/htdocs" plugin update --all)"
    wp_output="$(wp --path="$path/htdocs" core update)"
    wp --path="$path/htdocs" core update-db > /dev/null
    wp --path="$path/htdocs" language core update > /dev/null
    wp --path="$path/htdocs" theme update --all > /dev/null

    sudo chown -R $old_owner $path/htdocs

    echo "$plugin_output"
    echo "$wp_output"
    echo -e "============END================\n"

    #if customer email set, send email notification
    if [ ! -z "${config[clientemail]}" ]; then
      echo -e "$plugin_output\n$wp_output" | mail -s "[FutureLab Support] Your website has been updated" ${config[clientemail]}
    fi
  fi
done
