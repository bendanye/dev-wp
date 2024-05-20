if [[ -z $1 ]]; then
    echo "Enter the image name to view container logs"
    exit 0
fi

docker logs $(docker ps -a -q --filter ancestor=$1)
