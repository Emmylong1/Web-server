resource "aws_instance" "web-server" {
    ami = "xxxxxxx"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.az1.id
   security_groups = [aws_security_group.allow_web.id]

    tags = {
        Name = "web-server"
    }                        
} 


