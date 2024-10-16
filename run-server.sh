#!/bin/bash

cd db_migrations || exit
DUMP_SCHEMA_AFTER_MIGRATION=$DUMP_SCHEMA_AFTER_MIGRATION bundle exec rake db:migrate

if [[ $? != 0 ]]; then
 echo "Failed to migrate. Exiting."
 exit 1
fi
echo "DB migrate done!"

echo "Starting app server..."
exec /app/api

