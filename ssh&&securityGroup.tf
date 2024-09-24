resource "tls_private_key" "sshx_key" {
  algorithm = "RSA"             # Specify the key algorithm (RSA, ECDSA, etc.)
  rsa_bits  = 2048 
}
resource "aws_key_pair" "sshx_key" {
  key_name   = "bastion-keyx"
  public_key = tls_private_key.sshx_key.public_key_openssh  # استخدم المفتاح العام اللي اتولد
}

resource "local_file" "private_key" {
  filename = "${path.module}/bastion-key.pem"  # اسم الملف الذي سيتم حفظه
  content  = tls_private_key.sshx_key.private_key_pem  # محتوى المفتاح الخاص
}
resource "aws_security_group" "sg" {
  name   = "sg"
  vpc_id = aws_vpc.net.id
}

resource "aws_security_group_rule" "sequrity_groupSERVER" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id  = aws_security_group.bastion_sg.id 
  security_group_id = aws_security_group.sg.id
}
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Security group for the Bastion Host"
  vpc_id = aws_vpc.net.id
  ingress {
    description = "Allow ping from any specify IP"
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"

    cidr_blocks = ["102.190.145.239/32"]  
  }
    ingress {
    description      = "Allow SSH traffic"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["102.190.145.239/32"]  
    }

}

resource "aws_security_group" "sg_multitier" {
  name        = "multitier-sg"
  description = "Security group for the Bastion Host"
  vpc_id = aws_vpc.net.id
  ingress {
    description = "Allow ping from your any IP"
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
     cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  
    cidr_blocks = ["0.0.0.0/0"]
  }
}
