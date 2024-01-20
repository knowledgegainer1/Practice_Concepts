locals {
  Name= "${var.Project_name}-${var.Environment}"
  az_name= slice(data.aws_availability_zones.azs.names,0,2)
  
}