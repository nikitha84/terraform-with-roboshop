resource "aws_key_pair" "openvpn" {
  key_name   = "openvpn"
  public_key = file("C:\\Users\\Nipun\\.ssh\\openvpn.pub") # for mac use /
}

resource "aws_instance" "vpn" {
  ami           = local.ami_id
  instance_type = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  subnet_id = local.public_subnet_ids
  user_data = file("openvpn.sh")
  key_name = aws_key_pair.openvpn.key_name
   
  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-vpn"
    }
  )
}
resource "aws_eip" "vpn" {
  instance = aws_instance.vpn.id
  # vpc      = true
  domain = "vpc"
}




