#!/bin/bash

# source ./src/help.sh


handleParams(){
    while [[ $# -gt 0 ]]; do
        case $1 in
            -[a-zA-Z]*)
                for (( i=1; i<${#1}; i++ )); do
                    opt="${1:i:1}"
                    case "$opt" in 
                        j)
                            compression="bzip2"
                            ;;
                        J)
                            compression="xz"
                            ;;
                        q)
                            quiet=true
                            ;;
                        x)
                            output="extract"
                            ;;
                        c)
                            output="create"
                            ;;
                    esac
                done
                shift
                ;;
            -x)
                action="extract"
                shift
                ;;
            -c)
                action="create"
                shift
                ;;
            -j|--bzip2)
                compression="bzip2"
                shift
                ;;
            -J|--xz)
                compression="xz"
                shift
                ;;
            -h|--help)
                help_prompt
                ;;
            -q|--quiet)
                quiet=true
                shift
                ;;
            --)
                shift
                break
                ;;
            -*)
                echo "Unbekannte Option: $1"
                exit 1
                ;;
            *)
                targets+=("$1")
                shift
                ;;
        esac
    done
}