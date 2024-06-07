packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.0.0"
    }
  }
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "source_ami" {
  type    = string
  default = "ami-04b70fa74e45c3917"

}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ssh_username" {
  type    = string
  default = "ubuntu"
}
variable "GH_USERNAME" {
  type    = string
  default = ""
}

variable "GH_CREDS" {
  type    = string
  default = ""
}

variable "DOCKERHUB_USERNAME" {
  type    = string
  default = ""
}

variable "DOCKERHUB_CREDS" {
  type    = string
  default = ""
}

source "amazon-ebs" "my-ami" {
  region        = var.region
  source_ami    = var.source_ami
  instance_type = var.instance_type
  ssh_username  = var.ssh_username
  ami_name      = "jenkins-{{timestamp}}"
  tags = {
    Name = "Jenkins - {{timestamp}}"
  }
  vpc_id    = "vpc-023f27855f38a83dd"
  subnet_id = "subnet-06242053329a9c97d"
}

build {
  sources = ["sources.amazon-ebs.my-ami"]

  provisioner "file" {
    source      = "install-jenkins.sh"
    destination = "/tmp/install-jenkins.sh"
  }
  provisioner "shell" {
    inline = [
      "echo 'GH_USERNAME=${var.GH_USERNAME}' | sudo tee -a /etc/jenkins.env",
      "echo 'GH_CREDS=${var.GH_CREDS}' | sudo tee -a /etc/jenkins.env",
      "echo 'DOCKERHUB_USERNAME=${var.DOCKERHUB_USERNAME}' | sudo tee -a /etc/jenkins.env",
      "echo 'DOCKERHUB_CREDS=${var.DOCKERHUB_CREDS}' | sudo tee -a /etc/jenkins.env",
    ]
    environment_vars = [
      "GH_USERNAME=${var.GH_USERNAME}",
      "GH_CREDS=${var.GH_CREDS}",
      "DOCKERHUB_USERNAME=${var.DOCKERHUB_USERNAME}",
      "DOCKERHUB_CREDS=${var.DOCKERHUB_CREDS}"
    ]
  }

  provisioner "file" {
    source      = "install-nginx.sh"
    destination = "/tmp/install-nginx.sh"
  }

  provisioner "file" {
    source      = "configure-nginx.sh"
    destination = "/tmp/configure-nginx.sh"
  }

  provisioner "file" {
    source      = "jenkins.conf"
    destination = "/tmp/jenkins.conf"
  }

  provisioner "file" {
    source      = "plugins.txt"
    destination = "/tmp/plugins.txt"
  }
  provisioner "file" {
    source      = "casc.yaml"
    destination = "/tmp/casc.yaml"
  }

  provisioner "file" {
    source      = "job-dsl.groovy"
    destination = "/tmp/job-dsl.groovy"
  }
  provisioner "file" {
    source      = "gitcred.groovy"
    destination = "/tmp/gitcred.groovy"
  }
  provisioner "file" {
    source      = "dockercred.groovy"
    destination = "/tmp/dockercred.groovy"
  }

  provisioner "shell" {
    inline = [
      "sudo chmod +x /tmp/install-jenkins.sh",
      "sudo chmod +x /tmp/install-nginx.sh",
      "sudo chmod +x /tmp/configure-nginx.sh",
      "/tmp/install-jenkins.sh",
      "/tmp/install-nginx.sh",
      "/tmp/configure-nginx.sh",
    ]
  }


}
