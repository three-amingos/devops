resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits = 2048
}
resource "aws_key_pair" "keypair" {
  key_name = var.ssh_key_name
  public_key = tls_private_key.private_key.public_key_openssh
}
resource "local_file" "private_key" {
  content = tls_private_key.private_key.private_key_pem
  file_permission = "0600"
  filename = "${path.module}/eks-ssh-key/ssh_private_key.pem"
}