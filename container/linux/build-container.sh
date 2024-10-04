#!/bin/bash

echo "*** Building Container..."

echo "*** Checking for environment configuration file"

if test -f ".env"; then
    echo "*** .env file present..."
    echo "*** building container..."
    sudo docker compose build --no-cache
    echo "*** container built..."
    echo "*** to run... sudo docker compose up -d"
else
    echo "*** .env file not found, quitting..."
    exit 1
fi

