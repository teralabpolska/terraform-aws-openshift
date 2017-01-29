//  Define the RHEL 7.2 AMI by:
//  RedHat, Latest, x86_64, EBS, HVM, RHEL 7.2
data "aws_ami" "rhel7_2" {
  most_recent = true

  owners = ["309956199498"] // Red Hat's account ID.

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["RHEL-7.2*"]
  }
}

//  Create an SSH keypair
resource "aws_key_pair" "keypair" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

//  Launch configuration for the consul cluster auto-scaling group.
resource "aws_instance" "master" {
  ami                  = "${data.aws_ami.rhel7_2.id}"
  instance_type        = "${var.amisize}"
  subnet_id            = "${aws_subnet.public-subnet.id}"

  security_groups = [
    "${aws_security_group.openshift-vpc.id}",
    "${aws_security_group.openshift-public-access.id}",
  ]

  //  We need at least 30GB for OpenShift, let's be greedy...
  root_block_device {
    volume_size = 50
  }

  key_name = "${aws_key_pair.keypair.key_name}"

  tags {
    Name    = "OpenShift Master"
    Project = "openshift"
  }
}

//  Create the two nodes. This would be better as a Launch Configuration and
//  autoscaling group, but I'm keeping it simple...
resource "aws_instance" "node1" {
  ami                  = "${data.aws_ami.rhel7_2.id}"
  instance_type        = "${var.amisize}"
  subnet_id            = "${aws_subnet.public-subnet.id}"

  security_groups = [
    "${aws_security_group.openshift-vpc.id}",
    "${aws_security_group.openshift-public-access.id}",
  ]

  //  We need at least 30GB for OpenShift, let's be greedy...
  root_block_device {
    volume_size = 50
  }

  key_name = "${aws_key_pair.keypair.key_name}"

  tags {
    Name    = "OpenShift Node 1"
    Project = "openshift"
  }
}
resource "aws_instance" "node2" {
  ami                  = "${data.aws_ami.rhel7_2.id}"
  instance_type        = "${var.amisize}"
  subnet_id            = "${aws_subnet.public-subnet.id}"

  security_groups = [
    "${aws_security_group.openshift-vpc.id}",
    "${aws_security_group.openshift-public-access.id}",
  ]

  //  We need at least 30GB for OpenShift, let's be greedy...
  root_block_device {
    volume_size = 50
  }

  key_name = "${aws_key_pair.keypair.key_name}"

  tags {
    Name    = "OpenShift Node 2"
    Project = "openshift"
  }
}
