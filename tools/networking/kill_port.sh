if [[ -z $1 ]]; then
  echo "Please enter the port to kill"
  exit 1
fi

kill $(lsof -i :$1 | grep IPv6 | awk '{print $2}')
