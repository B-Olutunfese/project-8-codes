#application load balancer

resource "aws_elb" "project8-alb" {
  name               = "project8-alb"
  subnets = [
    aws_subnet.p8-web-sub1.id,
    aws_subnet.p8-web-sub2.id
  ]
 
  #listener
listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 5
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  tags = {
    Name = "project8-alb"
  }
}
  
#Create ALB Target group

resource "aws_lb_target_group" "ELB-TG-project8" {
  name     = "ELB-TG-project8"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.project8-vpc.id
}

#Create ELB Target group attachment for Instance 1/web server

resource "aws_lb_target_group_attachment" "elb-server-attachment1" {
  target_group_arn = aws_lb_target_group.ELB-TG-project8.arn
  target_id        = aws_instance.webserver1-project8.id

  depends_on       = [aws_instance.webserver1-project8]
}

#Create ELB Target group attachment for Instance 2/web server

resource "aws_lb_target_group_attachment" "elb-server-attachment2" {
  target_group_arn = aws_lb_target_group.ELB-TG-project8.arn
  target_id        = aws_instance.webserver2-project8.id

  depends_on       = [aws_instance.webserver2-project8]
}
