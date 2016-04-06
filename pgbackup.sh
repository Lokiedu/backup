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
export PGPASSWORD=$BACKUP_POSTGRES_PASSWORD
pg_dump -O --inserts -b -h $DB_PORT_5432_TCP_ADDR -U postgres -f /tmp/postgres.sql postgres
bzip2 -fq /tmp/postgres.sql
/usr/local/bin/s3backup.rb
