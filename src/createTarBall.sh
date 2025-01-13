createTarball(){
    compression=$1
    output=$2
    ddOutputPath=$3

    compressionOption="";

    case compression in
        none)
            compressionOption=""
            ;;
        bzip2)
            compressionOption="--bzip2"
            ;;
        xz)
            compressionOption="--xz"
            ;;
        lzip)
            compressionOption="--lzip"
            ;;
        lzop)
            compressionOption="--lzop"
            ;;
    esac
    
     if [ -z "$compressionOption" ]; then
        tar -cf "$output" "$ddOutputPath"
    else
        tar $compressionOption -cf "$output" "$ddOutputPath"
    fi
}
createTarball $1 $2 $3