createTarball(){
    output=$1
    ddOutputPath=$2
    tar -cf $output $ddOutputPath
}
