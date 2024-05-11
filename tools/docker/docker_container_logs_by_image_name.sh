if [[ -z $1 ]]; then
    echo "Enter the image name to remove"
    exit 0
fi

docker logs $(docker ps -a -q --filter ancestor=$1)