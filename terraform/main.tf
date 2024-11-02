terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider este
provider "aws" {
  region = "us-east-1"
}

#create a vpc

resource "aws_vpc" "building_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "building_vpc"
  }
}
# creamos la ip elastica
resource "aws_eip" "building_eip" {
  public_ipv4_pool= "amazon"
  tags = {
    Name = "building_eip"
  }
}

# creamos la subnet publica y privada
resource "aws_subnet" "private_building_subnet" {
  # asociamos la subnet al cidr de la vpc
  vpc_id     = aws_vpc.building_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "private_building_Subnet"
  }
}
resource "aws_subnet" "public_building_subnet" {
  vpc_id     = aws_vpc.building_vpc.id
  cidr_block = "10.0.100.0/24"
  
  #  indica que a las instancias lanzadas en la subred 
  #  se les debe asignar una dirección IP pública

  map_public_ip_on_launch = true

  tags = {
    Name = "public_building_subnet"
  }
}


# creamos el internet gateway

resource "aws_internet_gateway" "building_gateway" {
  vpc_id = aws_vpc.building_vpc.id

  tags = {
    Name = "Internet_gateway_building"
  }
}

# creamos el nat

resource "aws_nat_gateway" "building-nat" {
  
  allocation_id = aws_eip.building_eip.id
  subnet_id     = aws_subnet.public_building_subnet.id

  tags = {
    Name = "building-nat"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.building_gateway]
}

# crear la tabla de rutas
resource "aws_route_table" "building_route_table" {
  vpc_id = aws_vpc.building_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.building_gateway.id
  }


  tags = {
    Name = "building_route_table"
  }
}

# asociar la tabla de rutas

resource "aws_route_table_association" "building_associte_public" {
  subnet_id      = aws_subnet.public_building_subnet.id
  route_table_id = aws_route_table.building_route_table.id

}
