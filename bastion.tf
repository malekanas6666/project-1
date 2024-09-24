resource "aws_ebs_volume" "exampleBas" {
  availability_zone = "eu-central-1a"
  size              = 8

  tags = {
    Name = "Hello bastion"
  }
}

resource "aws_ebs_snapshot" "example_snapshot2" {
  volume_id = aws_ebs_volume.exampleBas.id

  tags = {
    Name = "HelloWorld_snap"
  }
}

resource "aws_ami" "example2" {
  name                = "terraform-example2"
  virtualization_type = "hvm"
  root_device_name    = "/dev/xvda"
  imds_support        = "v2.0" 
  ebs_block_device {
    device_name = "/dev/xvda"
    volume_size = 8
  snapshot_id = aws_ebs_snapshot.example_snapshot2.id
  }
}

resource "aws_instance" "bastion" {
  ami           = "ami-01626326122556d77"
  instance_type = "t2.micro"
  tags = {
    Name = "BastionHost"
  }
vpc_security_group_ids = [aws_security_group.bastion_sg.id]
subnet_id = aws_subnet.public.id
 key_name      = aws_key_pair.sshx_key.key_name 
 associate_public_ip_address = true
 
}
resource "aws_eip" "web_ip" {
  instance = aws_instance.bastion.id
}