
openTarball(){
    inputFile=$1
    
    tar -xf "$inputFile"
   
}
openTarball $1