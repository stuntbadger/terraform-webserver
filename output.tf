#This will show the External IP of the server in the console 
output "public_ip" {
  value = "${aws_instance.web.public_ip}"
}
