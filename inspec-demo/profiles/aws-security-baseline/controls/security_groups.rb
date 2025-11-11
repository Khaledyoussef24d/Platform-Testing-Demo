# Security Group Controls
# This control file tests AWS Security Group configurations

title 'Security Group Security'

allowed_ssh_cidr = input('allowed_ssh_cidr')

control 'sg-no-unrestricted-ssh' do
  impact 1.0
  title 'Ensure security groups do not allow unrestricted SSH access'
  desc 'Security groups should not allow SSH (port 22) access from 0.0.0.0/0'
  
  aws_security_groups.group_ids.each do |group_id|
    describe aws_security_group(group_id: group_id) do
      it { should_not allow_in(port: 22, ipv4_range: '0.0.0.0/0') }
    end
  end
end

control 'sg-no-unrestricted-rdp' do
  impact 1.0
  title 'Ensure security groups do not allow unrestricted RDP access'
  desc 'Security groups should not allow RDP (port 3389) access from 0.0.0.0/0'
  
  aws_security_groups.group_ids.each do |group_id|
    describe aws_security_group(group_id: group_id) do
      it { should_not allow_in(port: 3389, ipv4_range: '0.0.0.0/0') }
    end
  end
end

control 'sg-no-unrestricted-mysql' do
  impact 0.9
  title 'Ensure security groups do not allow unrestricted MySQL access'
  desc 'Security groups should not allow MySQL (port 3306) access from 0.0.0.0/0'
  
  aws_security_groups.group_ids.each do |group_id|
    describe aws_security_group(group_id: group_id) do
      it { should_not allow_in(port: 3306, ipv4_range: '0.0.0.0/0') }
    end
  end
end

control 'sg-no-unrestricted-postgresql' do
  impact 0.9
  title 'Ensure security groups do not allow unrestricted PostgreSQL access'
  desc 'Security groups should not allow PostgreSQL (port 5432) access from 0.0.0.0/0'
  
  aws_security_groups.group_ids.each do |group_id|
    describe aws_security_group(group_id: group_id) do
      it { should_not allow_in(port: 5432, ipv4_range: '0.0.0.0/0') }
    end
  end
end

control 'sg-has-description' do
  impact 0.5
  title 'Ensure security groups have descriptions'
  desc 'Security groups should have meaningful descriptions for audit purposes'
  
  aws_security_groups.group_ids.each do |group_id|
    describe aws_security_group(group_id: group_id) do
      its('description') { should_not be_empty }
      its('description') { should_not eq 'Managed by Terraform' }
    end
  end
end

control 'sg-default-not-in-use' do
  impact 0.8
  title 'Ensure default security group is not in use'
  desc 'Default security groups should not be used; create custom security groups instead'
  
  aws_security_groups.where(group_name: 'default').group_ids.each do |group_id|
    describe aws_security_group(group_id: group_id) do
      its('inbound_rules.count') { should eq 0 }
      its('outbound_rules.count') { should cmp <= 1 }
    end
  end
end
