terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
   
   resource "aws_vpc" "myvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "my_vpc_Bootcamp"
  }
}

resource "aws_subnet" "mypub" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "pubsub_bootcamp"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "IGW_Bootcamp"
  }
}


resource "aws_route_table" "pubRT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "pubRT_Bootcamp"
  }
}


resource "aws_route_table_association" "sub" {
  subnet_id      = aws_subnet.mypub.id
  route_table_id = aws_route_table.pubRT.id
}