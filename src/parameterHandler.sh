handleParams() {
    files_or_dirs=() 
    output=""
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                help_prompt
                exit 0
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
            -q|--quiet)
                quiet=true
                shift
                ;;
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
                            action="extract"
                            ;;
                        c)
                            action="create"
                            ;;
                        *)
                            echo "Unbekannte Option: -$opt"
                            exit 1
                            ;;
                    esac
                done
                shift
                ;;
            --)
                shift
                break
                ;;
            -* | --*)
                echo "Unbekannte Option: $1"
                exit 1
                ;;
            *)
                if [[ -z $output ]]; then
                    output="$1"
                else
                    files_or_dirs+=("$1")
                fi
                shift
                ;;
        esac
    done

    files=("${files_or_dirs[@]}")
}
