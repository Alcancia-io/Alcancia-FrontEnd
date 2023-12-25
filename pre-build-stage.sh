ENV_FILE=.env.dev
if [ -f "$ENV_FILE" ]; then
    cp .env.dev .env
else
    echo "$ENV_FILE does not exist."
    exit 1
fi
