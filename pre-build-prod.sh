ENV_FILE=.env.prod
if [ -f "$ENV_FILE" ]; then
    cp .env.prod .env
else
    echo "$ENV_FILE does not exist."
    exit
fi
