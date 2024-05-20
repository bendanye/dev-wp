if [[ -z $1 ]]; then
    echo "Enter the image name to remove"
    exit 0
fi

IMAGE_NAME=$1

shift

docker logs $(docker ps -a -q --filter ancestor=$IMAGE_NAME) $@
