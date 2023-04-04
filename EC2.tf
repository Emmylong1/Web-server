resource "aws_instance" "web-server" {
    ami = "ami-007855ac798b5175e"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.az1.id
   security_groups = [aws_security_group.allow_web.id]

    tags = {
        Name = "web-server"
    }                        
} 


