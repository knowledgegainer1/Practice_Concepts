resource "aws_vpc_peering_connection" "peering" {
  count = var.is_peering_required ? 1:0
  vpc_id = aws_vpc.main.id
  peer_vpc_id = var.acceptor_vpc_id =="" ? data.aws_vpc.default.id : var.acceptor_vpc_id
  auto_accept = var.acceptor_vpc_id =="" ? true : false
  tags = merge(#merge is used to merge maps 
    var.common_tags,var.vpc_peering_tags,{
        Name="${local.Name}"
    }
  )
}

resource "aws_route" "acceptor_route" {
  count = var.is_peering_required &&  var.acceptor_vpc_id == "" ? 1 : 0
route_table_id = data.aws_route_table.default.id
destination_cidr_block = var.vpc_cidr
vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}
resource "aws_route" "public_rout" {
  count = var.is_peering_required &&  var.acceptor_vpc_id == "" ? 1 : 0
route_table_id = aws_route_table.public.id
destination_cidr_block = data.aws_vpc.default.cidr_block
vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}
resource "aws_route" "private_rout" {
  count = var.is_peering_required &&  var.acceptor_vpc_id == "" ? 1 : 0
route_table_id = aws_route_table.private.id
destination_cidr_block = data.aws_vpc.default.cidr_block
vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}
resource "aws_route" "database_rout" {
  count = var.is_peering_required &&  var.acceptor_vpc_id == "" ? 1 : 0
route_table_id = aws_route_table.database.id
destination_cidr_block = data.aws_vpc.default.cidr_block
vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id  # why [ ] is used means id count come dt will become list type
}