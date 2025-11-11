# IAM Security Controls
# This control file tests AWS IAM configurations

title 'IAM Security'

control 'iam-root-no-access-keys' do
  impact 1.0
  title 'Ensure root account has no access keys'
  desc 'The root account should not have any access keys; use IAM users instead'
  
  describe aws_iam_root_user do
    it { should_not have_access_key }
  end
end

control 'iam-mfa-enabled-root' do
  impact 1.0
  title 'Ensure MFA is enabled for root account'
  desc 'Multi-factor authentication should be enabled for the root account'
  
  describe aws_iam_root_user do
    it { should have_mfa_enabled }
  end
end

control 'iam-password-policy' do
  impact 0.9
  title 'Ensure IAM password policy meets requirements'
  desc 'IAM password policy should enforce strong passwords'
  
  describe aws_iam_password_policy do
    it { should exist }
    it { should require_uppercase_characters }
    it { should require_lowercase_characters }
    it { should require_numbers }
    it { should require_symbols }
    its('minimum_password_length') { should be >= 14 }
    it { should prevent_password_reuse }
  end
end

control 'iam-users-mfa-enabled' do
  impact 0.9
  title 'Ensure MFA is enabled for all IAM users with console access'
  desc 'All IAM users with console access should have MFA enabled'
  
  aws_iam_users.where(has_console_password: true).usernames.each do |username|
    describe aws_iam_user(username: username) do
      it { should have_mfa_enabled }
    end
  end
end

control 'iam-no-policies-attached-to-users' do
  impact 0.7
  title 'Ensure IAM policies are not attached directly to users'
  desc 'IAM policies should be attached to groups, not directly to users'
  
  aws_iam_users.usernames.each do |username|
    describe aws_iam_user(username: username) do
      its('attached_policy_names') { should be_empty }
    end
  end
end

control 'iam-unused-credentials' do
  impact 0.8
  title 'Ensure unused IAM user credentials are removed'
  desc 'IAM user credentials that have not been used in 90 days should be removed'
  
  aws_iam_users.usernames.each do |username|
    describe aws_iam_user(username: username) do
      its('access_keys') { should_not exist }
    end
  end
end

control 'iam-access-keys-rotated' do
  impact 0.8
  title 'Ensure access keys are rotated every 90 days'
  desc 'IAM access keys should be rotated regularly to reduce security risk'
  
  aws_iam_access_keys.where { created_date < Time.now - (90 * 86400) }.entries.each do |key|
    describe "Access key #{key.access_key_id}" do
      subject { key }
      it { should_not exist }
    end
  end
end

control 'iam-role-policy-least-privilege' do
  impact 0.9
  title 'Ensure IAM roles follow least privilege principle'
  desc 'IAM roles should have minimal permissions necessary'
  
  aws_iam_roles.role_names.each do |role_name|
    describe aws_iam_role(role_name: role_name) do
      it { should_not have_inline_policies }
    end
  end
end
