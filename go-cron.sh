#!/bin/bash
#
# This file is a part of libertysoil.org website
# Copyright (C) 2015  Loki Education (Social Enterprise)
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Check configuration variables

: "${BACKUP_DAYS_TO_KEEP:?Variable must be set and non-empty}"
: "${BACKUP_SCHEDULE:?Variable must be set and non-empty}"
: "${BACKUP_POSTGRES_PASSWORD:?Variable must be set and non-empty}"
: "${BACKUP_S3_BUCKET:?Variable must be set and non-empty}"
: "${BACKUP_S3_DIR:?Variable must be set and non-empty}"
: "${BACKUP_AWS_REGION:?Variable must be set and non-empty}"
: "${BACKUP_AWS_ACCESS_KEY_ID:?Variable must be set and non-empty}"
: "${BACKUP_AWS_SECRET_ACCESS_KEY:?Variable must be set and non-empty}"
[ -z "$DB_PORT_5432_TCP_ADDR" ] && echo "ERROR: Link to database container is not defined" && exit 1

# Run the cron

exec go-cron -s "$BACKUP_SCHEDULE" -- /usr/local/bin/pgbackup.sh
