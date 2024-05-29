
# Genrate a key for Instance  
resource "tls_private_key" "hsitpublic_key" {
  algorithm = "RSA"
  rsa_bits  = 4096 
}
resource "aws_key_pair" "hsitpublic_key_pair" {
  key_name   = "hsitpublicinsprod.pem"
  public_key = tls_private_key.hsitpublic_key.public_key_openssh
}
resource "local_file" "hsitpublicserverkey" {
   filename = "hsitpublicinsprod.pem"
   content = tls_private_key.hsitpublic_key.private_key_pem
}


# crate a public server in vpc
resource "aws_instance" "hsitmanagementpublicserverprod" {
  ami = "ami-00fa32593b478ad6e"
  instance_type = "t2.micro"
  key_name = aws_key_pair.hsitpublic_key_pair.key_name
  security_groups = [aws_security_group.hsitmanagmentpublicsgprod.id]
  subnet_id = aws_subnet.hsitmanagementsubnet1prod.id
  tags = {
    Name = "hsit-management-public-server-prod"
  }
}