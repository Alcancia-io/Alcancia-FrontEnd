#!/bin/sh

# The default execution directory of this script is the ci_scripts directory.
cd $CI_WORKSPACE # change working directory to the root of your cloned repo.

// Create .env.prod and .env.dev files in the root of your project with environment variables.

echo "Creating .env.prod file..."
echo "API_URL=$API_URL" > .env.prod
echo "MEXICO_INE_FLOW_ID=$MEXICO_INE_FLOW_ID" >> .env.prod
echo "METAMAP_CLIENT_ID=$METAMAP_CLIENT_ID" >> .env.prod
echo "DOMINICAN_FLOW_ID=$DOMINICAN_FLOW_ID" >> .env.prod
echo "MEXICO_RESIDENTS_FLOW_ID=$MEXICO_RESIDENTS_FLOW_ID" >> .env.prod

echo "Creating .env.dev file..."
echo "API_URL=$API_URL" > .env.dev
echo "MEXICO_INE_FLOW_ID=$MEXICO_INE_FLOW_ID" >> .env.dev
echo "METAMAP_CLIENT_ID=$METAMAP_CLIENT_ID" >> .env.dev
echo "DOMINICAN_FLOW_ID=$DOMINICAN_FLOW_ID" >> .env.dev
echo "MEXICO_RESIDENTS_FLOW_ID=$MEXICO_RESIDENTS_FLOW_ID" >> .env.dev

exit 0


