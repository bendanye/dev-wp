SCRIPT_DIR=$( dirname -- "$0"; )

WORK_LOG_DIR="${SCRIPT_DIR}/examples"

OPEN_FILE=$1

if [[ $OPEN_FILE == "current" ]]; then
  file=$(ls "${WORK_LOG_DIR}"/*.md | grep -v "template.md" | sort -r | head -n 1)
elif [[ $OPEN_FILE == "previous" ]]; then
  file=$(ls "${WORK_LOG_DIR}"/*.md | grep -v "template.md" | sort -r | sed -n '2p')
fi

if [ -n "$file" ]; then
  code "$file"
else
  echo "No files found to open."
fi
