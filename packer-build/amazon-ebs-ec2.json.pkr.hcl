locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "ebs_backed" {
  access_key    = var.aws_access_key
  ami_name      = "packer-builder-goldenami-${local.timestamp}"
  instance_type = "t2.micro"
  region        = var.aws_region
  secret_key    = var.aws_secret_key
  source_ami    = var.aws_ami_id
  ssh_username  = "ubuntu"
  run_tags = {
    Name  = "Golden-AMI"
  }
  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      name                = "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"
      root-device-type    = "ebs"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  temporary_key_pair_name = "ubuntu-packer-{{timestamp}}"
}

