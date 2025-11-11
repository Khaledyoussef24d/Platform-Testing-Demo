# S3 Bucket Security Controls
# This control file tests S3 bucket security configurations

title 'S3 Bucket Security'

control 's3-bucket-encryption' do
  impact 1.0
  title 'Ensure S3 buckets have encryption enabled'
  desc 'S3 buckets should have server-side encryption enabled to protect data at rest'
  
  aws_s3_buckets.bucket_names.each do |bucket_name|
    describe aws_s3_bucket(bucket_name: bucket_name) do
      it { should have_default_encryption_enabled }
    end
  end
end

control 's3-bucket-versioning' do
  impact 0.8
  title 'Ensure S3 buckets have versioning enabled'
  desc 'S3 bucket versioning helps protect against accidental deletion and provides audit trail'
  
  aws_s3_buckets.bucket_names.each do |bucket_name|
    describe aws_s3_bucket(bucket_name: bucket_name) do
      it { should have_versioning_enabled }
    end
  end
end

control 's3-bucket-public-access' do
  impact 1.0
  title 'Ensure S3 buckets block public access'
  desc 'S3 buckets should have public access blocked to prevent unauthorized data exposure'
  
  aws_s3_buckets.bucket_names.each do |bucket_name|
    describe aws_s3_bucket(bucket_name: bucket_name) do
      it { should have_access_logging_enabled }
    end
    
    # Check public access block settings
    describe aws_s3_bucket(bucket_name: bucket_name) do
      its('bucket_acl.grants') { should_not include(grantee: { type: 'Group', uri: 'http://acs.amazonaws.com/groups/global/AllUsers' }) }
    end
  end
end

control 's3-bucket-ssl-requests-only' do
  impact 0.9
  title 'Ensure S3 buckets enforce SSL/TLS'
  desc 'S3 buckets should enforce SSL/TLS for all requests'
  
  aws_s3_buckets.bucket_names.each do |bucket_name|
    describe aws_s3_bucket(bucket_name: bucket_name) do
      it { should have_secure_transport_enabled }
    end
  end
end

control 's3-bucket-logging' do
  impact 0.7
  title 'Ensure S3 buckets have access logging enabled'
  desc 'S3 bucket access logging provides audit trail for bucket access'
  
  aws_s3_buckets.bucket_names.each do |bucket_name|
    describe aws_s3_bucket(bucket_name: bucket_name) do
      it { should have_access_logging_enabled }
    end
  end
end
