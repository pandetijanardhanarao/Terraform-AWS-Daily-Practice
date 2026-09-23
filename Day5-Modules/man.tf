resource "aws_instance" "ec2_instance" {
    instance_type = var.instance_type
    ami = var.ami
    tags={
        Name="ec2_instance"
    }
  
}