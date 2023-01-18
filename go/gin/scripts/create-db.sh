#!/bin/bash

# This is a script to create a database in RDS
# Usage: ./create-db.sh <name>
# Example: ./create-db.sh pr_1

# Usage in waypoint.hcl
# 
# ```hcl
#   build {
#     hook {
#       when    = "before"
#       command = ["sh", "./scripts/create-db.sh", var.branch]
#     }
#   # ...
# ```

# check if argument is passed
if [ -z "$1" ]
  then
    echo "No argument supplied"
    echo "Usage: ./create-db.sh <name>"
    echo "Example: ./create-db.sh pr_1"
    exit 1
fi

# check if psql is installed
if ! [ -x "$(command -v psql)" ]; then
  echo 'Error: psql is not installed.' >&2
  exit 1
else
  echo "psql is installed"
  exit 0
fi


exit 0

# The rest of this works :), but temporarily is not being executed...
# TODO: hide password or connection string behind env variable

DB__HOST="FIXME"
DB__PASS="FIXME"
DB__USER="postgres"
DB__PORT="5432"
DB__NAME=$1

DB_CONNECTION_STRING="postgres://$DB__USER:$DB__PASS@$DB__HOST:$DB__PORT"

# Bootstrap 100 databases ... ?
# for i in {1..100}
# do
#   echo "Creating database pr_$i"
#   psql "$DB_CONNECTION_STRING" \
#     -c "CREATE DATABASE pr_$i"
# done


i=$1
echo "*********************************"
echo "Creating database $i"
echo "*********************************"
psql "$DB_CONNECTION_STRING" \
  -c "CREATE DATABASE $i"

if [ $? -eq 0 ]; then
  echo "✅ Database $i created successfully"
else
  echo "❌ Database $i creation failed"
fi