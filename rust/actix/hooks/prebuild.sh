BREAK="==========================="

# Exit 1 if no argument is passed
if [ -z "$1" ]; then
    echo "No branch passed";
    exit 1;
fi
echo "Branch: $1";
db_name=${1//-/_};
echo "db_name: $db_name";



echo $BREAK
echo "==> Running terraform apply"
echo $BREAK
# apply ./terraform/main.tf
terraform -chdir=terraform apply -auto-approve >/dev/null

echo $BREAK
echo "==> Getting outputs from terraform"
echo $BREAK
DB_HOST=$(terraform -chdir=terraform output aurora_postgresql_serverlessv2_cluster_endpoint | jq -r);
DB_USER=$(terraform -chdir=terraform output aurora_postgresql_serverlessv2_cluster_master_username | jq -r);
DB_PASSWORD=$(terraform -chdir=terraform output aurora_postgresql_serverlessv2_cluster_master_password | jq -r);
DB_PORT=$(terraform -chdir=terraform output aurora_postgresql_serverlessv2_cluster_port | jq -r);
DB_DATABASE=postgres

echo "DB_HOST: $DB_HOST"
echo "DB_USER: $DB_USER"
echo "DB_PASSWORD: $DB_PASSWORD"
echo "DB_PORT: $DB_PORT"
echo "DB_DATABASE: $DB_DATABASE"

echo $BREAK
echo "==> Formatting DB_NAME"
DB_URL=postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_DATABASE
# Format DB_NAME
DB_NAME=$db_name
# replace - with _
DB_NAME=${DB_NAME//-/_}
# replace / with _
DB_NAME=${DB_NAME//\//_}
# remove "wp_" prefix from DB_NAME
DB_NAME=${DB_NAME#wp_}
# add "wp_" prefix to DB_NAME
DB_NAME=wp_$DB_NAME
echo "DB_NAME: $DB_NAME"
echo $BREAK


echo $BREAK
echo "==> Creating database"
echo $BREAK
# Create database if not exists
# https://stackoverflow.com/a/36591842/9823455
psql $DB_URL -tc "SELECT 1 FROM pg_database WHERE datname = '$DB_NAME'" | grep -q 1;
if [ $? -ne 0 ]; then
    echo "Creating database $DB_NAME";
    psql $DB_URL -c "CREATE DATABASE $DB_NAME";
else
    echo "Database $DB_NAME already exists";
fi
echo ""

