if [[ -z $1 ]]; then
    echo "Enter the image name to remove"
    exit 0
fi

IMAGE_NAME=$1

docker container rm -f $(docker ps -a -q --filter ancestor=$IMAGE_NAME)

docker rmi $IMAGE_NAME