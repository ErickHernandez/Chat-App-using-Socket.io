resource "aws_elb" "chatapp" {
  name = "chatapp-elb"
  subnets = [aws_subnet.chatapp-subnet-public-1.id, aws_subnet.chatapp-subnet-public-2.id]

  # access_logs {
  #   bucket        = "foo"
  #   bucket_prefix = "bar"
  #   interval      = 60
  # }

  listener {
    instance_port     = 5000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:5000/"
    interval            = 30
  }

  instances                   = [aws_instance.chatapp1.id, aws_instance.chatapp2.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 180
  connection_draining         = true
  connection_draining_timeout = 180

  tags = {
    Name = "chatapp-elb"
  }
}