require "shrine"
require "shrine/storage/file_system"
require "shrine/storage/s3"

aws_credentials = Rails.application.credentials.aws

s3_credential = {
  access_key_id:     ENV.fetch('AWS_ACCESS_KEY_ID', aws_credentials.present? ? aws_credentials[:access_key_id] : 'AKIAIOSFODNN7EXAMPLE'),
  secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY', aws_credentials.present? ? aws_credentials[:secret_access_key] : 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'),
}

s3_prod_app = s3_credential.merge({
  bucket: ENV.fetch('AWS_S3_BUCKET_PROD', "kyabachan-rails-prod"),
  region: ENV.fetch('AWS_S3_REGION_PROD', "ap-northeast-1"),
});

s3_dev_app = s3_credential.merge({
  bucket: ENV.fetch('AWS_S3_BUCKET_DEV', "kyabachan-rails-dev"),
  region: ENV.fetch('AWS_S3_REGION_DEV', "ap-northeast-1"),
});

if Rails.env.production?
  Shrine.storages = {
    cache: Shrine::Storage::S3.new(prefix: "cache", **s3_prod_app),
    store: Shrine::Storage::S3.new(prefix: "store", **s3_prod_app),
  }
else
  Shrine.storages = {
    cache: Shrine::Storage::S3.new(prefix: "cache", **s3_dev_app),
    store: Shrine::Storage::S3.new(prefix: "store", **s3_dev_app),
  }
end


# Use shrine with activerecord
Shrine.plugin :activerecord

# There is no need to re-upload the file when a validation error occurs.
# see: https://github.com/shrinerb/shrine/blob/master/doc/plugins/cached_attachment_data.md
Shrine.plugin :cached_attachment_data

# Don't trust the client's metadata, the server extracts meta information again
# see: https://github.com/shrinerb/shrine/blob/master/doc/plugins/restore_cached_data.md
Shrine.plugin :restore_cached_data

# Prepare a Rack endpoint to update files
# see: https://github.com/shrinerb/shrine/blob/master/doc/plugins/upload_endpoint.md
Shrine.plugin :upload_endpoint
