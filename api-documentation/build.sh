#!/usr/bin/env bash
set -e

display_usage() {
    echo "Production build"
    echo
    echo "Usage: $0 -m MODE"
    echo "required options:"
    echo "m     Set deployment mode. Allowed values:"
    echo "          - dev"
    echo "          - staging"
    echo "          - production"
    echo
}

if [ "$#" -eq 0 ]; then
    display_usage
    exit 0;
fi

while getopts "m:" flag
do
    case "${flag}" in
        m) MODE=${OPTARG};;
        \?) display_usage
          ;;
    esac
done

if [ -z ${MODE+x} ]; then
    echo "-m was not set. Please specify a mode"
    exit 1;
fi

if [ "$MODE" != "dev" ] && [ "$MODE" != "staging" ] && [ "$MODE" != "production" ]; then
    echo "Invalid mode specified. Valid options are: staging, production"
    echo "  - dev"
    echo "  - staging"
    echo "  - production"
    exit 1;
fi

# change to script directory
cd "$(dirname "$0")"

echo "npm install"
npm install
if [ $? -ne 0 ]; then { echo "Install failed, aborting." ; exit 1; } fi

echo "Building and Publishing API Docs"
echo "npm run api:publish-v1 --stage=$MODE"
npm run api:publish-v1 --stage=$MODE
if [ $? -ne 0 ]; then { echo "Publish failed, aborting." ; exit 1; } fi

echo "Copying index.html"
echo "cp Public/index.html dist/"
cp Public/index.html dist/
if [ $? -ne 0 ]; then { echo "Copy index.html failed, aborting." ; exit 1; } fi

echo "Finished"
