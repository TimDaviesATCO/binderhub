locals = {
  cluster_name                 = "binder.geo-analytics.io"
  master_autoscaling_group_ids = ["${aws_autoscaling_group.master-ap-southeast-2b-masters-binder-geo-analytics-io.id}"]
  master_security_group_ids    = ["${aws_security_group.masters-binder-geo-analytics-io.id}"]
  masters_role_arn             = "${aws_iam_role.masters-binder-geo-analytics-io.arn}"
  masters_role_name            = "${aws_iam_role.masters-binder-geo-analytics-io.name}"
  node_autoscaling_group_ids   = ["${aws_autoscaling_group.nodes-binder-geo-analytics-io.id}"]
  node_security_group_ids      = ["${aws_security_group.nodes-binder-geo-analytics-io.id}"]
  node_subnet_ids              = ["${aws_subnet.ap-southeast-2a-binder-geo-analytics-io.id}", "${aws_subnet.ap-southeast-2b-binder-geo-analytics-io.id}"]
  nodes_role_arn               = "${aws_iam_role.nodes-binder-geo-analytics-io.arn}"
  nodes_role_name              = "${aws_iam_role.nodes-binder-geo-analytics-io.name}"
  region                       = "ap-southeast-2"
  route_table_public_id        = "${aws_route_table.binder-geo-analytics-io.id}"
  subnet_ap-southeast-2a_id    = "${aws_subnet.ap-southeast-2a-binder-geo-analytics-io.id}"
  subnet_ap-southeast-2b_id    = "${aws_subnet.ap-southeast-2b-binder-geo-analytics-io.id}"
  vpc_cidr_block               = "${aws_vpc.binder-geo-analytics-io.cidr_block}"
  vpc_id                       = "${aws_vpc.binder-geo-analytics-io.id}"
}

output "cluster_name" {
  value = "binder.geo-analytics.io"
}

output "master_autoscaling_group_ids" {
  value = ["${aws_autoscaling_group.master-ap-southeast-2b-masters-binder-geo-analytics-io.id}"]
}

output "master_security_group_ids" {
  value = ["${aws_security_group.masters-binder-geo-analytics-io.id}"]
}

output "masters_role_arn" {
  value = "${aws_iam_role.masters-binder-geo-analytics-io.arn}"
}

output "masters_role_name" {
  value = "${aws_iam_role.masters-binder-geo-analytics-io.name}"
}

output "node_autoscaling_group_ids" {
  value = ["${aws_autoscaling_group.nodes-binder-geo-analytics-io.id}"]
}

output "node_security_group_ids" {
  value = ["${aws_security_group.nodes-binder-geo-analytics-io.id}"]
}

output "node_subnet_ids" {
  value = ["${aws_subnet.ap-southeast-2a-binder-geo-analytics-io.id}", "${aws_subnet.ap-southeast-2b-binder-geo-analytics-io.id}"]
}

output "nodes_role_arn" {
  value = "${aws_iam_role.nodes-binder-geo-analytics-io.arn}"
}

output "nodes_role_name" {
  value = "${aws_iam_role.nodes-binder-geo-analytics-io.name}"
}

output "region" {
  value = "ap-southeast-2"
}

output "route_table_public_id" {
  value = "${aws_route_table.binder-geo-analytics-io.id}"
}

output "subnet_ap-southeast-2a_id" {
  value = "${aws_subnet.ap-southeast-2a-binder-geo-analytics-io.id}"
}

output "subnet_ap-southeast-2b_id" {
  value = "${aws_subnet.ap-southeast-2b-binder-geo-analytics-io.id}"
}

output "vpc_cidr_block" {
  value = "${aws_vpc.binder-geo-analytics-io.cidr_block}"
}

output "vpc_id" {
  value = "${aws_vpc.binder-geo-analytics-io.id}"
}

provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_autoscaling_group" "master-ap-southeast-2b-masters-binder-geo-analytics-io" {
  name                 = "master-ap-southeast-2b.masters.binder.geo-analytics.io"
  launch_configuration = "${aws_launch_configuration.master-ap-southeast-2b-masters-binder-geo-analytics-io.id}"
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = ["${aws_subnet.ap-southeast-2b-binder-geo-analytics-io.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "binder.geo-analytics.io"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "master-ap-southeast-2b.masters.binder.geo-analytics.io"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    value               = "master-ap-southeast-2b"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/master"
    value               = "1"
    propagate_at_launch = true
  }

  metrics_granularity = "1Minute"
  enabled_metrics     = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
}

resource "aws_autoscaling_group" "nodes-binder-geo-analytics-io" {
  name                 = "nodes.binder.geo-analytics.io"
  launch_configuration = "${aws_launch_configuration.nodes-binder-geo-analytics-io.id}"
  max_size             = 2
  min_size             = 2
  vpc_zone_identifier  = ["${aws_subnet.ap-southeast-2a-binder-geo-analytics-io.id}", "${aws_subnet.ap-southeast-2b-binder-geo-analytics-io.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "binder.geo-analytics.io"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "nodes.binder.geo-analytics.io"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    value               = "nodes"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/node"
    value               = "1"
    propagate_at_launch = true
  }

  metrics_granularity = "1Minute"
  enabled_metrics     = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
}

resource "aws_ebs_volume" "b-etcd-events-binder-geo-analytics-io" {
  availability_zone = "ap-southeast-2b"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster                               = "binder.geo-analytics.io"
    Name                                            = "b.etcd-events.binder.geo-analytics.io"
    "k8s.io/etcd/events"                            = "b/b"
    "k8s.io/role/master"                            = "1"
    "kubernetes.io/cluster/binder.geo-analytics.io" = "owned"
  }
}

resource "aws_ebs_volume" "b-etcd-main-binder-geo-analytics-io" {
  availability_zone = "ap-southeast-2b"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster                               = "binder.geo-analytics.io"
    Name                                            = "b.etcd-main.binder.geo-analytics.io"
    "k8s.io/etcd/main"                              = "b/b"
    "k8s.io/role/master"                            = "1"
    "kubernetes.io/cluster/binder.geo-analytics.io" = "owned"
  }
}

resource "aws_iam_instance_profile" "masters-binder-geo-analytics-io" {
  name = "masters.binder.geo-analytics.io"
  role = "${aws_iam_role.masters-binder-geo-analytics-io.name}"
}

resource "aws_iam_instance_profile" "nodes-binder-geo-analytics-io" {
  name = "nodes.binder.geo-analytics.io"
  role = "${aws_iam_role.nodes-binder-geo-analytics-io.name}"
}

resource "aws_iam_role" "masters-binder-geo-analytics-io" {
  name               = "masters.binder.geo-analytics.io"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_masters.binder.geo-analytics.io_policy")}"
}

resource "aws_iam_role" "nodes-binder-geo-analytics-io" {
  name               = "nodes.binder.geo-analytics.io"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_nodes.binder.geo-analytics.io_policy")}"
}

resource "aws_iam_role_policy" "masters-binder-geo-analytics-io" {
  name   = "masters.binder.geo-analytics.io"
  role   = "${aws_iam_role.masters-binder-geo-analytics-io.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_masters.binder.geo-analytics.io_policy")}"
}

resource "aws_iam_role_policy" "nodes-binder-geo-analytics-io" {
  name   = "nodes.binder.geo-analytics.io"
  role   = "${aws_iam_role.nodes-binder-geo-analytics-io.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_nodes.binder.geo-analytics.io_policy")}"
}

resource "aws_internet_gateway" "binder-geo-analytics-io" {
  vpc_id = "${aws_vpc.binder-geo-analytics-io.id}"

  tags = {
    KubernetesCluster                               = "binder.geo-analytics.io"
    Name                                            = "binder.geo-analytics.io"
    "kubernetes.io/cluster/binder.geo-analytics.io" = "owned"
  }
}

resource "aws_key_pair" "kubernetes-binder-geo-analytics-io-0fe81f1618872b20986d2c1fc3602436" {
  key_name   = "kubernetes.binder.geo-analytics.io-0f:e8:1f:16:18:87:2b:20:98:6d:2c:1f:c3:60:24:36"
  public_key = "${file("${path.module}/data/aws_key_pair_kubernetes.binder.geo-analytics.io-0fe81f1618872b20986d2c1fc3602436_public_key")}"
}

resource "aws_launch_configuration" "master-ap-southeast-2b-masters-binder-geo-analytics-io" {
  name_prefix                 = "master-ap-southeast-2b.masters.binder.geo-analytics.io-"
  image_id                    = "ami-db8546b9"
  instance_type               = "t2.medium"
  key_name                    = "${aws_key_pair.kubernetes-binder-geo-analytics-io-0fe81f1618872b20986d2c1fc3602436.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.masters-binder-geo-analytics-io.id}"
  security_groups             = ["${aws_security_group.masters-binder-geo-analytics-io.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_master-ap-southeast-2b.masters.binder.geo-analytics.io_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 64
    delete_on_termination = true
  }

  lifecycle = {
    create_before_destroy = true
  }

  enable_monitoring = false
}

resource "aws_launch_configuration" "nodes-binder-geo-analytics-io" {
  name_prefix                 = "nodes.binder.geo-analytics.io-"
  image_id                    = "ami-db8546b9"
  instance_type               = "t2.medium"
  key_name                    = "${aws_key_pair.kubernetes-binder-geo-analytics-io-0fe81f1618872b20986d2c1fc3602436.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.nodes-binder-geo-analytics-io.id}"
  security_groups             = ["${aws_security_group.nodes-binder-geo-analytics-io.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_nodes.binder.geo-analytics.io_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 128
    delete_on_termination = true
  }

  lifecycle = {
    create_before_destroy = true
  }

  enable_monitoring = false
}

resource "aws_route" "0-0-0-0--0" {
  route_table_id         = "${aws_route_table.binder-geo-analytics-io.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.binder-geo-analytics-io.id}"
}

resource "aws_route_table" "binder-geo-analytics-io" {
  vpc_id = "${aws_vpc.binder-geo-analytics-io.id}"

  tags = {
    KubernetesCluster                               = "binder.geo-analytics.io"
    Name                                            = "binder.geo-analytics.io"
    "kubernetes.io/cluster/binder.geo-analytics.io" = "owned"
    "kubernetes.io/kops/role"                       = "public"
  }
}

resource "aws_route_table_association" "ap-southeast-2a-binder-geo-analytics-io" {
  subnet_id      = "${aws_subnet.ap-southeast-2a-binder-geo-analytics-io.id}"
  route_table_id = "${aws_route_table.binder-geo-analytics-io.id}"
}

resource "aws_route_table_association" "ap-southeast-2b-binder-geo-analytics-io" {
  subnet_id      = "${aws_subnet.ap-southeast-2b-binder-geo-analytics-io.id}"
  route_table_id = "${aws_route_table.binder-geo-analytics-io.id}"
}

resource "aws_security_group" "masters-binder-geo-analytics-io" {
  name        = "masters.binder.geo-analytics.io"
  vpc_id      = "${aws_vpc.binder-geo-analytics-io.id}"
  description = "Security group for masters"

  tags = {
    KubernetesCluster                               = "binder.geo-analytics.io"
    Name                                            = "masters.binder.geo-analytics.io"
    "kubernetes.io/cluster/binder.geo-analytics.io" = "owned"
  }
}

resource "aws_security_group" "nodes-binder-geo-analytics-io" {
  name        = "nodes.binder.geo-analytics.io"
  vpc_id      = "${aws_vpc.binder-geo-analytics-io.id}"
  description = "Security group for nodes"

  tags = {
    KubernetesCluster                               = "binder.geo-analytics.io"
    Name                                            = "nodes.binder.geo-analytics.io"
    "kubernetes.io/cluster/binder.geo-analytics.io" = "owned"
  }
}

resource "aws_security_group_rule" "all-master-to-master" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-binder-geo-analytics-io.id}"
  source_security_group_id = "${aws_security_group.masters-binder-geo-analytics-io.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-master-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-binder-geo-analytics-io.id}"
  source_security_group_id = "${aws_security_group.masters-binder-geo-analytics-io.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-node-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-binder-geo-analytics-io.id}"
  source_security_group_id = "${aws_security_group.nodes-binder-geo-analytics-io.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "https-external-to-master-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.masters-binder-geo-analytics-io.id}"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "master-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.masters-binder-geo-analytics-io.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.nodes-binder-geo-analytics-io.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-to-master-tcp-1-2379" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-binder-geo-analytics-io.id}"
  source_security_group_id = "${aws_security_group.nodes-binder-geo-analytics-io.id}"
  from_port                = 1
  to_port                  = 2379
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-2382-4000" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-binder-geo-analytics-io.id}"
  source_security_group_id = "${aws_security_group.nodes-binder-geo-analytics-io.id}"
  from_port                = 2382
  to_port                  = 4000
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-4003-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-binder-geo-analytics-io.id}"
  source_security_group_id = "${aws_security_group.nodes-binder-geo-analytics-io.id}"
  from_port                = 4003
  to_port                  = 65535
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-udp-1-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-binder-geo-analytics-io.id}"
  source_security_group_id = "${aws_security_group.nodes-binder-geo-analytics-io.id}"
  from_port                = 1
  to_port                  = 65535
  protocol                 = "udp"
}

resource "aws_security_group_rule" "ssh-external-to-master-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.masters-binder-geo-analytics-io.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ssh-external-to-node-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.nodes-binder-geo-analytics-io.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_subnet" "ap-southeast-2a-binder-geo-analytics-io" {
  vpc_id            = "${aws_vpc.binder-geo-analytics-io.id}"
  cidr_block        = "172.20.32.0/19"
  availability_zone = "ap-southeast-2a"

  tags = {
    KubernetesCluster                               = "binder.geo-analytics.io"
    Name                                            = "ap-southeast-2a.binder.geo-analytics.io"
    SubnetType                                      = "Public"
    "kubernetes.io/cluster/binder.geo-analytics.io" = "owned"
    "kubernetes.io/role/elb"                        = "1"
  }
}

resource "aws_subnet" "ap-southeast-2b-binder-geo-analytics-io" {
  vpc_id            = "${aws_vpc.binder-geo-analytics-io.id}"
  cidr_block        = "172.20.64.0/19"
  availability_zone = "ap-southeast-2b"

  tags = {
    KubernetesCluster                               = "binder.geo-analytics.io"
    Name                                            = "ap-southeast-2b.binder.geo-analytics.io"
    SubnetType                                      = "Public"
    "kubernetes.io/cluster/binder.geo-analytics.io" = "owned"
    "kubernetes.io/role/elb"                        = "1"
  }
}

resource "aws_vpc" "binder-geo-analytics-io" {
  cidr_block           = "172.20.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    KubernetesCluster                               = "binder.geo-analytics.io"
    Name                                            = "binder.geo-analytics.io"
    "kubernetes.io/cluster/binder.geo-analytics.io" = "owned"
  }
}

resource "aws_vpc_dhcp_options" "binder-geo-analytics-io" {
  domain_name         = "ap-southeast-2.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    KubernetesCluster                               = "binder.geo-analytics.io"
    Name                                            = "binder.geo-analytics.io"
    "kubernetes.io/cluster/binder.geo-analytics.io" = "owned"
  }
}

resource "aws_vpc_dhcp_options_association" "binder-geo-analytics-io" {
  vpc_id          = "${aws_vpc.binder-geo-analytics-io.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.binder-geo-analytics-io.id}"
}

terraform = {
  required_version = ">= 0.9.3"
}
