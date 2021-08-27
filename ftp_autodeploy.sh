#!/bin/bash

# default project root
arg_directory="./"


while test $# -gt 0; do
    case "$1" in
        --host)
            shift
            arg_host=$1
            shift
            ;;
        --username)
            shift
            arg_username=$1
            shift
            ;;
        --password)
            shift
            arg_password=$1
            shift
            ;;
        --help)
            echo ""
            echo "Autodeployer shell script tool"
            echo "        -- by mrpi --"
            echo ""
            echo "--host:      Define hostname for ftp connection"
            echo "--username:  Define ftp username"
            echo "--password:  Define passwor for specified ftp username"
            echo "--directory: Define project root, default is current directory exp: ./path/to/folider/"
            echo ""
            exit 1;
            ;;
        --directory)
            shift
            arg_directory=$1
            shift
            ;;
        *)
            echo "$1 is not a recognized flag!"
            exit 1;
            ;;
    esac
done  


exec_ftp_script="
quote USER $arg_username
quote PASS $arg_password
cd public_html
cd dev
ascii
"


scanner(){
    for entry in "$search_dir"$1
    do
        dir=${entry:2}
        if [ -d "$entry" ]; then
            exec_ftp_script=$exec_ftp_script"mkdir ${dir/#${2:2}}
            "
            
            scanner "./"${entry:2}"/*" $2
        fi

        if [ -f "$entry" ]; then
            exec_ftp_script=$exec_ftp_script"put $2${dir/#${2:2}} ${dir/#${2:2}}
            "
        fi
    done    
}


scanner $arg_directory"*" $arg_directory


ftp -p -nv $arg_host << END_SCRIPT
$exec_ftp_script
END_SCRIPT
