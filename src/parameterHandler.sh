#!/bin/bash
handleParams(){
    case $1 in 
        -x)
        output="extract"
        shift
        ;;
        -c)
        output="create"
        shift
        ;;
    esac

    while [[ $# -gt 0 ]]; do
        case $1 in
            -[a-zA-Z]*)
                for (( i=1; i<${#1}; i++ )); do
                    opt="${1:i:1}"
                    case "$opt" in 
                        j)
                            filter="bzip2"
                            ;;
                        J)
                            filter="xz"
                            ;;
                        q)
                            quiet=true
                            ;;
                    esac
                done
                shift
                ;;
            -j|--bzip2)
                filter="bzip2"
                shift
                ;;
            -J|--xz)
                filter="xz"
                shift
                ;;
            --lzip)
                filter="lzip"
                shift
                ;;
            --lzop)
                filter="lzop"
                shift
                ;;
            -h|--help)
                show_help
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