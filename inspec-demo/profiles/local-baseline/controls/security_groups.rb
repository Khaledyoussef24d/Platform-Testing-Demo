# Security Group Controls for Local Testing
# This control file tests AWS Security Group configurations on LocalStack

title 'Security Group Security (Local)'

control 'sg-exists' do
  impact 0.7
  title 'Ensure security groups exist in LocalStack'
  desc 'Verify that security groups can be created and listed in LocalStack'
  
  describe aws_security_groups do
    it { should exist }
  end
end

control 'sg-no-unrestricted-ssh' do
  impact 1.0
  title 'Ensure security groups do not allow unrestricted SSH access'
  desc 'Security groups should not allow SSH (port 22) access from 0.0.0.0/0'
  
  only_if { aws_security_groups.group_ids.any? }
  
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
  
  only_if { aws_security_groups.group_ids.any? }
  
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
  
  only_if { aws_security_groups.group_ids.any? }
  
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
  
  only_if { aws_security_groups.group_ids.any? }
  
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
  
  only_if { aws_security_groups.group_ids.any? }
  
  aws_security_groups.group_ids.each do |group_id|
    sg = aws_security_group(group_id: group_id)
    next if sg.group_name == 'default'  # Skip default security group
    
    describe sg do
      its('description') { should_not be_empty }
    end
  end
end
