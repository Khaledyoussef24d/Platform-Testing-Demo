# S3 Bucket Security Controls for Local Testing
# This control file tests S3 bucket security configurations on LocalStack

title 'S3 Bucket Security (Local)'

control 's3-bucket-exists' do
  impact 0.7
  title 'Ensure S3 buckets exist in LocalStack'
  desc 'Verify that S3 buckets can be created and listed in LocalStack'
  
  # This will pass if any buckets exist, or skip if none exist
  describe aws_s3_buckets do
    it { should exist }
  end
end

control 's3-bucket-encryption' do
  impact 1.0
  title 'Ensure S3 buckets have encryption enabled'
  desc 'S3 buckets should have server-side encryption enabled to protect data at rest'
  
  only_if { aws_s3_buckets.bucket_names.any? }
  
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
  
  only_if { aws_s3_buckets.bucket_names.any? }
  
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
  
  only_if { aws_s3_buckets.bucket_names.any? }
  
  aws_s3_buckets.bucket_names.each do |bucket_name|
    # Check public access block settings
    describe aws_s3_bucket(bucket_name: bucket_name) do
      its('bucket_acl.grants') { should_not include(grantee: { type: 'Group', uri: 'http://acs.amazonaws.com/groups/global/AllUsers' }) }
    end
  end
end
