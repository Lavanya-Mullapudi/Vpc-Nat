# Allocate Elastic IP Address
# terraform aws allocate elastic ip
resource "aws_eip" "eip-for-nat-gateway" {
  vpc    = true

  tags   = {
    Name = "eip"
  }
}


# Create Nat Gateway in Public Subnet
# terraform create aws nat gateway
resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = aws_eip.eip-for-nat-gateway.id 
  subnet_id     = aws_subnet.subnet1-public.id

  tags   = {
    Name = "Nat-gw-pb-1"
  }
}


# Create Private Route Table  and Add Route Through Nat Gateway
# terraform aws create route table
resource "aws_route_table" "private-route-table" {
  vpc_id            = aws_vpc.default.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat-gateway.id
  }

  tags   = {
    Name = "pvt-RT"
  }
}

# Associate Private Subnet 1 with "Private Route Table"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "private-subnet-route-table-association" {
  subnet_id         = aws_subnet.subnet-private.id
  route_table_id    = aws_route_table.private-route-table.id
}
