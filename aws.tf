# aws.tf
# aws access key and aws secret key ares stored in the terrafrom.tfvars file 
variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}

provider "aws" {
	region = "eu-west-2"
	access_key = "${var.AWS_ACCESS_KEY}"
	secret_key = "${var.AWS_SECRET_KEY}"
}

#ssh key 
resource "aws_key_pair" "laptopkey" {
	key_name = "laptopkey"
	public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD1O/ShVdePwSTpeViy4RCSlyWJMrdJI8SNQW0/yHALuaQTufAvuDjY1rY/uMG8k9Jt3uz+yFExaxHPzsTJLKI4y9o2diM46d6pfjTYs9bYgNMxccyy/pNxQ05AU5pz4urWkgY3bAwrVQghh/Qv1EIekaNLeRyuv0hEGYKB7mS4EVH95vhfrP+mhBTFzQS8BxM4puVthd7DH1MM61DaUFFc7WVA4Li+PTJlwMUKGMjC6Wt3mHVeL+Ee4Gxh/1fjRwfOAp/eqFV1X0lwJRkGzLT7LIzJmDHNdR9ibwt46iI8IxO75A+rdNiZD6LkkHMWMV3eVyQIQKD9t2DkjH9u+FNJ stuntbadger@laptop "
}

#webserver
resource "aws_instance" "web" {
	ami = "ami-c12dcda6"
	instance_type = "t2.micro"
	key_name = "${aws_key_pair.laptopkey.key_name}"
	user_data = "${file("install.sh")}"
        vpc_security_group_ids = [
		"${aws_security_group.external.id}"
	]

	tags {
		Name = "WebServer"
	     }
	}

# CREATE THE SECURITY GROUP THAT'S APPLIED TO THE EC2 INSTANCE

resource "aws_security_group" "external" {
    name = "WebServer_external" # vanilla-stage_external

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        self = true
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

