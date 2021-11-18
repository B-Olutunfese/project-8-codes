#vpc

resource "aws_vpc" "project8-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "project8-vpc"
  }
}

#web-subnets

resource "aws_subnet" "p8-web-sub1" {
  vpc_id     = aws_vpc.project8-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "p8-web-sub1"
  }
}

resource "aws_subnet" "p8-web-sub2" {
  vpc_id     = aws_vpc.project8-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-west-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "p8-web-sub2"
  }
}

#application-subnets

resource "aws_subnet" "p8-applicatn-sub1" {
  vpc_id     = aws_vpc.project8-vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "eu-west-2a"
  tags = {
    Name = "p8-applicatn-sub1"
  }
}

resource "aws_subnet" "p8-applicatn-sub2" {
  vpc_id     = aws_vpc.project8-vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "eu-west-2b"
  tags = {
    Name = "p8-applicatn-sub2"
  }
}


#internet gateway

resource "aws_internet_gateway" "project8-igw" {
  vpc_id = aws_vpc.project8-vpc.id

  tags = {
    Name = "project8-igw"
  }
}


#public rout table
resource "aws_route_table" "project8-pub-rt" {
  vpc_id = aws_vpc.project8-vpc.id

  route = []

  tags = {
    Name = "project8-pub-rt"
  }
}

#private route table

resource "aws_route_table" "project8-private-rt" {
  vpc_id = aws_vpc.project8-vpc.id

  route = []

  tags = {
    Name = "project8-private-rt"
  }
}


#route table association-web subnet

resource "aws_route_table_association" "project8-webrt-asso1" {
  subnet_id      = aws_subnet.p8-web-sub1.id
  route_table_id = aws_route_table.project8-pub-rt.id
}

resource "aws_route_table_association" "project8-webrt-asso2" {
  subnet_id      = aws_subnet.p8-web-sub2.id
  route_table_id = aws_route_table.project8-pub-rt.id
}

#route table asocciation application subnet

resource "aws_route_table_association" "project8-rt-asso1" {
  subnet_id      = aws_subnet.p8-applicatn-sub1.id
  route_table_id = aws_route_table.project8-private-rt.id
}

resource "aws_route_table_association" "project8-rt-asso2" {
  subnet_id      = aws_subnet.p8-applicatn-sub2.id
  route_table_id = aws_route_table.project8-private-rt.id
}

#route

resource "aws_route" "project8-route" {
  route_table_id = aws_route_table.project8-pub-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id     = aws_internet_gateway.project8-igw.id
}