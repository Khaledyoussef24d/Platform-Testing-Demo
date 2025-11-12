# IAM Security Controls for Local Testing
# This control file tests AWS IAM configurations on LocalStack

title 'IAM Security (Local)'

control 'iam-roles-exist' do
  impact 0.7
  title 'Ensure IAM roles exist in LocalStack'
  desc 'Verify that IAM roles can be created and listed in LocalStack'
  
  describe aws_iam_roles do
    it { should exist }
  end
end

control 'iam-no-policies-attached-to-users' do
  impact 0.7
  title 'Ensure IAM policies are not attached directly to users'
  desc 'IAM policies should be attached to groups or roles, not directly to users'
  
  only_if { aws_iam_users.usernames.any? }
  
  aws_iam_users.usernames.each do |username|
    describe aws_iam_user(username: username) do
      its('attached_policy_names') { should be_empty }
    end
  end
end

control 'iam-role-policy-least-privilege' do
  impact 0.9
  title 'Ensure IAM roles follow least privilege principle'
  desc 'IAM roles should have minimal permissions necessary'
  
  only_if { aws_iam_roles.role_names.any? }
  
  aws_iam_roles.role_names.each do |role_name|
    # Skip AWS service-linked roles
    next if role_name.start_with?('AWSServiceRoleFor')
    
    describe aws_iam_role(role_name: role_name) do
      it { should_not have_inline_policies }
    end
  end
end
