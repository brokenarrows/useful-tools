#!/bin/bash

echo "copying worker file to supervisor"
cp /var/www/provision/supervisor/default-worker.conf /etc/supervisor/conf.d/default-worker.conf

echo "Forcing supervisor to re-read configuration files"
supervisorctl reread

echo "Update supervisor workers"
supervisorctl update

echo "Restart workers"
supervisorctl restart default-worker:*