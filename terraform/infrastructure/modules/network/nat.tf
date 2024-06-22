resource "aws_nat_gateway" "nat_gw_1" {
  allocation_id = aws_eip.nat_gw_1.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "main-nat-gateway-1"
  }
}

resource "aws_nat_gateway" "nat_gw_2" {
  allocation_id = aws_eip.nat_gw_2.id
  subnet_id     = aws_subnet.public_subnet_2.id

  tags = {
    Name = "main-nat-gateway-2"
  }
}
