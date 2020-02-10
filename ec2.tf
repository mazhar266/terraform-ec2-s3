provider "aws" {
 access_key = "ACCESS_KEY_HERE"
 secret_key = "SECRET_KEY_HERE"
 region = "REGION_HERE"
}

resource "aws_instance" "web" {
  ami = "ami-0a7f2b5b6b87eaa1b" # this is ami for Ubuntu 18.04 LTS
  instance_type = "t2.micro" # this is instance type
  associate_public_ip_address=true
  key_name = "my-key" # name of pem key in aws console
  security_groups = [ # previously made security groups
    "security_group_id_1",
    "security_group_id_2 if any"
  ]
  subnet_id = "subnet_id_here"
  tags = { # we want to add as many tags as possible, it's helpful
    Name = "project-name"
    Mode = "dev"
  }
  provisioner "remote-exec" { # optional
    inline = [ # this gets executed on created ec2 instance
      # install docker and compose on the first run
      "sudo apt update",
      "sudo apt upgrade -y",
      "sudo apt install docker.io -y",
      "sudo apt install docker-compose -y",
    ]
# connection to be used by provisioner to perform remote executions
    connection {
      # use public IP of the instance to connect to it.
      host          = "${aws_instance.web.public_ip}"
      type          = "ssh"
      user          = "ubuntu" # username from the OS image
      private_key   = "${file("./my-key.pem")}" # file path
      timeout       = "10m" # let's wait for instance
      agent         = false
    }
  }
}
