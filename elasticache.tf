resource "aws_elasticache_subnet_group" "redis" {
  name        = "${var.name}-redis"
  subnet_ids  = ["${aws_subnet.datastore_subnet.*.id}"]
  description = "${var.name} redis"
}

resource "aws_elasticache_parameter_group" "redis" {
  name        = "${var.name}-redis"
  family      = "${var.elasticache_config["family"]}"
  description = "${var.name} redis"
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "${var.elasticache_config["cluster_id"]}"
  engine               = "${var.elasticache_config["engine"]}"
  engine_version       = "${var.elasticache_config["engine_version"]}"
  maintenance_window   = "${var.elasticache_config["maintenance_window"]}"
  node_type            = "${var.elasticache_config["node_type"]}"
  num_cache_nodes      = 1
  parameter_group_name = "${aws_elasticache_parameter_group.redis.id}"
  port                 = 6379
  subnet_group_name    = "${aws_elasticache_subnet_group.redis.name}"
  security_group_ids   = ["${aws_security_group.redis.id}"]

  tags {
    Name = "${var.name}-redis"
  }
}
