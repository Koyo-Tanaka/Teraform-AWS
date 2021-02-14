# vpc
resource "aws_vpc" "this" {
    cidr_block = "192.168.0.0/16"

    tags = {
        Name = "eks-vpc_example"
    }
}

# subnet
resource "aws_subnet" "public01" {
    vpc_id     = aws_vpc.this.id
    cidr_block = "192.168.0.0/18"
    map_public_ip_on_launch = true
    tags = {
        Name = "eks-vpc-public01_example"
    }
}
resource "aws_subnet" "public02" {
    vpc_id     = aws_vpc.this.id
    cidr_block = "192.168.64.0/18"
    map_public_ip_on_launch = true
    tags = {
        Name = "eks-vpc-public02_example"
    }
}
resource "aws_subnet" "private01" {
    vpc_id     = aws_vpc.this.id
    cidr_block = "192.168.128.0/18"

    tags = {
        Name = "eks-vpc-private01_example"
    }
}
resource "aws_subnet" "private02" {
    vpc_id     = aws_vpc.this.id
    cidr_block = "192.168.192.0/18"

    tags = {
        Name = "eks-vpc-private02_example"
    }
}

# route table(public)
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.this.id

    tags = {
        Name = "eks-public-subnet_example"
    }
}
resource "aws_internet_gateway" "this" {
    vpc_id = aws_vpc.this.id
}
resource "aws_route" "public" {
    destination_cidr_block = "0.0.0.0/0"
    route_table_id         = aws_route_table.public.id
    gateway_id             = aws_internet_gateway.this.id
}
resource "aws_route_table_association" "public01" {
    subnet_id      = aws_subnet.public01.id
    route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public02" {
    subnet_id      = aws_subnet.public02.id
    route_table_id = aws_route_table.public.id
}

# route table(private)
resource "aws_route_table" "private01" {
    vpc_id = aws_vpc.this.id
    tags = {
        Name = "eks-private-subnet01_example"
    }
}
resource "aws_eip" "nat01" {
    vpc = true
    tags = {
        Name = "eks-natgw-01_example"
    }
}
resource "aws_nat_gateway" "nat01" {
    subnet_id     = aws_subnet.private01.id
    allocation_id = aws_eip.nat01.id
    tags = {
        Name = "eks-nat-01_example"
    }
}
resource "aws_route" "private01" {
    destination_cidr_block = "0.0.0.0/0"
    route_table_id         = aws_route_table.private01.id
    nat_gateway_id         = aws_nat_gateway.nat01.id
}
resource "aws_route_table_association" "private01" {
    subnet_id      = aws_subnet.private01.id
    route_table_id = aws_route_table.private01.id
}

resource "aws_route_table" "private02" {
    vpc_id = aws_vpc.this.id
    tags = {
        Name = "eks-private-subnet02_example"
    }
}
resource "aws_eip" "nat02" {
    vpc = true
    tags = {
        Name = "eks-natgw-02_example"
    }
}
resource "aws_nat_gateway" "nat02" {
    subnet_id     = aws_subnet.private02.id
    allocation_id = aws_eip.nat02.id
    tags = {
        Name = "eks-nat-02_example"
    }
}
resource "aws_route" "private02" {
    destination_cidr_block = "0.0.0.0/0"
    route_table_id         = aws_route_table.private02.id
    nat_gateway_id         = aws_nat_gateway.nat02.id
}
resource "aws_route_table_association" "private02" {
    subnet_id      = aws_subnet.private02.id
    route_table_id = aws_route_table.private02.id
}