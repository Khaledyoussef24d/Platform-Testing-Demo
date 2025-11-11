# CloudTrail Security Controls
# This control file tests AWS CloudTrail configurations

title 'CloudTrail Security'

control 'cloudtrail-enabled' do
  impact 1.0
  title 'Ensure CloudTrail is enabled in all regions'
  desc 'CloudTrail should be enabled to log all AWS API calls for audit purposes'
  
  describe aws_cloudtrail_trails do
    it { should exist }
  end
  
  aws_cloudtrail_trails.trail_arns.each do |trail|
    describe aws_cloudtrail_trail(trail) do
      it { should be_multi_region_trail }
      it { should be_logging }
    end
  end
end

control 'cloudtrail-log-file-validation' do
  impact 0.9
  title 'Ensure CloudTrail log file validation is enabled'
  desc 'CloudTrail log file validation ensures logs have not been tampered with'
  
  aws_cloudtrail_trails.trail_arns.each do |trail|
    describe aws_cloudtrail_trail(trail) do
      it { should have_log_file_validation_enabled }
    end
  end
end

control 'cloudtrail-encrypted' do
  impact 0.9
  title 'Ensure CloudTrail logs are encrypted at rest'
  desc 'CloudTrail logs should be encrypted using KMS to protect sensitive data'
  
  aws_cloudtrail_trails.trail_arns.each do |trail|
    describe aws_cloudtrail_trail(trail) do
      it { should be_encrypted }
    end
  end
end

control 'cloudtrail-integrated-with-cloudwatch' do
  impact 0.8
  title 'Ensure CloudTrail is integrated with CloudWatch Logs'
  desc 'CloudTrail should send logs to CloudWatch for real-time monitoring'
  
  aws_cloudtrail_trails.trail_arns.each do |trail|
    describe aws_cloudtrail_trail(trail) do
      its('cloud_watch_logs_log_group_arn') { should_not be_nil }
    end
  end
end
