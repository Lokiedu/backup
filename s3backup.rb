#!/usr/bin/env ruby
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
require 'time'  
require 'aws-sdk'
require 'fileutils'

bucket_name = ENV['BACKUP_S3_BUCKET']
subdir_name = ENV['BACKUP_S3_DIR']

aws_region  = ENV['BACKUP_AWS_REGION']
aws_key     = ENV['BACKUP_AWS_ACCESS_KEY_ID']
aws_secret  = ENV['BACKUP_AWS_SECRET_ACCESS_KEY']

keep_time   = ENV['BACKUP_DAYS_TO_KEEP'].to_int * 60 * 60 * 24

time = Time.now.strftime("%Y%m%d.%H%M%S")  
filename = "postgres.#{time}.sql.bz2"  
filepath = "/tmp/#{filename}"

FileUtils.mv('/tmp/postgres.sql.bz2', filepath)

# verify file exists and file size is > 0 bytes
unless File.exists?(filepath) && File.new(filepath).size > 0  
  raise "Database was not backed up"
end

s3 = Aws::S3::Resource.new(region: aws_region, access_key_id: aws_key, secret_access_key: aws_secret)

bucket = s3.bucket(bucket_name)
object = bucket.object("#{subdir_name}/#{filename}")
object.upload_file(Pathname.new(filepath))

if object.exists?  
  FileUtils.rm(filepath)
else  
  raise "S3 Object wasn't created"
end

objects = bucket.objects.select do |object|  
  time = object.last_modified
  name = object.key
  time < Time.now - keep_time and name.start_with?("#{subdir_name}/postgres")
end  

objects.each(&:delete)
