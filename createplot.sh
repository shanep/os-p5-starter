#!/usr/bin/env bash
function usage() {
    echo "$0 usage:" && grep " .)\ #" $0
    exit 0
}

[ $# -eq 0 ] && usage
while getopts "c:p:s:i:f:h" arg; do
    case $arg in
    c) # The number of consumers (default 4)
        numc=${OPTARG}
        ;;
    p) # The number of producers (default 4)
        nump=${OPTARG}
        ;;
    s) # The starting size of the bounded queue (default 10)
        size=${OPTARG}
        ;;
    i) # The starting number of simulated items (default 10000)
        items=${OPTARG}
        ;;
    f) # The plot file name
        name=${OPTARG}
        ;;
    h | *) # Display help.
        usage
        exit 0
        ;;
    esac
done

if [ "$name" == "" ]; then
    usage
    exit 0
fi

if [ "$size" == "" ]; then
    size=10
fi

if [ "$numc" == "" ]; then
    numc=4
fi

if [ "$nump" == "" ]; then
    nump=4
fi

if [ "$items" == "" ]; then
    items=10000
fi

if [ -e ./build/myprogram ]; then
    rm -f *.dat
    for p in {1..2}; do
        for c in {1..2}; do
            for s in {1..20}; do
                ./build/myprogram -p "$p" -c "$c" -i "$items" -s "$size" >>"data$p$c.dat"
                items=$(($items + 10000))
            done
            items=10000
        done
        items=10000
    done

    gnuplot -e "filename='$name.png'" graph.plt
    echo "Created plot $name.png from data.dat file"
else
    echo "myprogram is not present in the build directory. Did you compile your code?"
fi
