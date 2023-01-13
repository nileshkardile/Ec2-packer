
variable "aws_access_key" {
  type    = string
  default = ""
}

variable "aws_ami_id" {
  type    = string
  default = ""
}

variable "aws_region" {
  type    = string
  default = ""
}

variable "aws_secret_key" {
  type    = string
  default = ""
}

data "amazon-ami" "ami_filter" {
  access_key = "${var.aws_access_key}"
  filters = {
    name                = "${var.aws_ami_id}"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = false
  owners      = ["amazon, aws-marketplace"]
  region      = "${var.aws_region}"
  secret_key  = "${var.aws_secret_key}"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "ebs_backed" {
  name          = "Golden-Ami"
  access_key    = "${var.aws_access_key}"
  ami_name      = "packer-builder-goldenami-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "${var.aws_region}"
  secret_key    = "${var.aws_secret_key}"
  source_ami    = "${data.amazon-ami.ami_filter.id}"
  ssh_username  = "ubuntu"
}

build {
  sources = ["source.amazon-ebs.ebs_backed"]

  provisioner "shell" {
    script = "./packer-build/provision-script.sh"
  }

}
