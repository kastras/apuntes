resource "aws_instance" "web" {
  ami           = "ami-0ec28fc9814fce254"
  instance_type = "t2.micro"

  tags = {
    Name = "${var.web}-${var.entorno}"
  }
}