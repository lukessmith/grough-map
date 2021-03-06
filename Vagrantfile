# ------------------------------
#  GROUGH MAP ENVIRONMENT
#  Luke S. Smith 2016.
#  Copyright (c) grough Limited.
#  luke.smith@grough.co.uk
# ------------------------------

Vagrant.configure("2") do |config|
  config.vm.provision :shell, run: "always", privileged: false, :path => "bin/linux/bootstrap.sh"

  config.vm.provider "virtualbox" do |v, override|
    v.name = "map-system.vm.grough.local"
	v.memory = 2048
	v.cpus = 1
	
    override.vm.box = "ubuntu/trusty64"
    override.vm.hostname = "map-system.vm.grough.local"
    override.vm.network :private_network, ip: "192.168.232.2"
  end
  
  config.vm.provider "aws" do |aws, override|
	aws.access_key_id = ENV['AWS_ACCESS_KEY_ID']
	aws.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
	aws.keypair_name = ENV['AWS_KEYPAIR_NAME']
	
	aws.instance_type = ENV['AWS_INSTANCE_TYPE']
	aws.region = ENV['AWS_REGION']
	aws.security_groups = [ ENV['AWS_SECURITY_GROUPS'] ]
	aws.ami = ENV['AWS_AMI']
	aws.iam_instance_profile_arn = ENV['AWS_IP_ARN']
	
	aws.block_device_mapping = [{ 'DeviceName' => '/dev/sda1', 'Ebs.VolumeSize' => ENV['AWS_EBS_SIZE'] }]
	
	aws.tags = {
	  'Source' => 'Vagrant'
	}
	
	override.ssh.username = "ubuntu"
	override.ssh.private_key_path = ENV['AWS_KEY_FILE']
	override.vm.box = "dummy"
	
	override.vm.synced_folder '.', '/vagrant', 
	  type: 'rsync',
	  create: true,
	  owner: 'ubuntu',
	  group: 'ubuntu',
	  rsync__args: [ '--verbose', '--archive', '-z' ],
	  rsync__auto: false,
	  rsync__verbose: true,
	  rsync__rsync_path: 'sudo rsync',
	  rsync__exclude: [
		"*.lnk",
		"*.bat", 
		"*.tif", 
		"*.tiff", 
		"*.pbf",
		"*.png",
		"*.jpg",
		".gitignore",
		".gitattributes",
		".vagrant/",
		".vagrant-aws/",
		".git/", 
		"volatile",
		"bin/win32",
		"bin/linux/Cascadenik", 
		"bin/linux/CVTool/cvtool",
		"bin/linux/LASTools",
		"product",
		"source/cartography",
		"source/eagg",
		"source/grid",
		"source/natural-england",
		"source/nrw",
		"source/os/opname",
		"source/os/opmplc",
		"source/os/bdline",
		"source/os/oprvrs",
		"source/os/oproad",
		"source/os/vmdvec",
		"source/os/codepo",
		"source/os/source_email.txt",
		"source/os-terrain",
		"source/terrain-composite",
		"source/env.sh"
	  ]
  end
end
