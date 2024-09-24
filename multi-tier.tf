resource "aws_ebs_volume" "example" {
  availability_zone = "eu-central-1a"
  size              = 8

  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_ebs_snapshot" "example_snapshot" {
  volume_id = aws_ebs_volume.example.id

  tags = {
    Name = "HelloWorld_snap"
  }
}

resource "aws_ami" "example" {
  name                = "terraform-example"
  virtualization_type = "hvm"
  root_device_name    = "/dev/xvda"
  imds_support        = "v2.0" 
  ebs_block_device {
    device_name = "/dev/xvda"
    volume_size = 8
  snapshot_id = aws_ebs_snapshot.example_snapshot.id
  
  }
}


resource "aws_instance" "multitier" {
  ami           = "ami-03d1e9769333fb5b4"
  instance_type = "t2.micro"
  tags = {
    Name = "multtiertest"
  }
  vpc_security_group_ids = [aws_security_group.sg_multitier.id]
  subnet_id = aws_subnet.public.id
   associate_public_ip_address = true
}

