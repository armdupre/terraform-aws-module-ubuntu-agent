resource "aws_instance" "Instance" {
	disable_api_termination = local.InstanceDisableApiTermination
	instance_initiated_shutdown_behavior = local.InstanceInstanceInitiatedShutdownBehavior
	ami = data.aws_ami.Ami.image_id
	instance_type = local.InstanceType
	monitoring = local.InstanceMonitoring
	key_name = local.SshKeyName
	iam_instance_profile = aws_iam_instance_profile.IamInstanceProfile.id
	placement_group = local.PlacementGroupId
	tags = {
		Name = local.InstanceName
		Owner = local.UserEmailTag
		Project = local.UserProjectTag
	}
	user_data = local.init_cli
	network_interface {
		network_interface_id = aws_network_interface.Eth0.id
		device_index = "0"
	}
	network_interface {
		network_interface_id = aws_network_interface.Eth1.id
		device_index = "1"
	}
	network_interface {
		network_interface_id = aws_network_interface.Eth2.id
		device_index = "2"
	}
	root_block_device {
		delete_on_termination = local.InstanceEbsDeleteOnTermination
		volume_type = local.InstanceEbsVolumeType
	}
	timeouts {
		create = "9m"
		delete = "5m"
	}
}

resource "aws_network_interface" "Eth0" {
	description = local.Eth0Name
	source_dest_check = local.InterfaceSourceDestCheck
	subnet_id = local.Eth0SubnetId
	security_groups = [
		local.Eth0SecurityGroupId
	]
	private_ips = [ local.Eth0PrivateIpAddress ]
	tags = {
		Name = local.Eth0Name
		Owner = local.UserEmailTag
		Project = local.UserProjectTag
	}
}

resource "aws_network_interface" "Eth1" {
	description = local.Eth1Name
	source_dest_check = local.InterfaceSourceDestCheck
	subnet_id = local.Eth1SubnetId
	security_groups = [
		local.Eth1SecurityGroupId
	]
	private_ips = local.Eth1PrivateIpAddresses
	tags = {
		Name = local.Eth1Name
		Owner = local.UserEmailTag
		Project = local.UserProjectTag
	}
}

resource "aws_network_interface" "Eth2" {
	description = local.Eth2Name
	source_dest_check = local.InterfaceSourceDestCheck
	subnet_id = local.Eth2SubnetId
	security_groups = [
		local.Eth2SecurityGroupId
	]
	private_ips = local.Eth2PrivateIpAddresses
	tags = {
		Name = local.Eth2Name
		Owner = local.UserEmailTag
		Project = local.UserProjectTag
	}
}

resource "aws_eip" "Eth0ElasticIp" {
	domain = "vpc"
	network_interface = aws_network_interface.Eth0.id
	depends_on = [
		aws_instance.Instance
	]
}

resource "time_sleep" "SleepDelay" {
	create_duration = local.SleepDelay

	depends_on = [
		aws_instance.Instance
	]
}