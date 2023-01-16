locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "ebs_backed" {
  access_key    = var.aws_access_key
  ami_name      = "packer-builder-goldenami-${local.timestamp}"
  instance_type = "t2.micro"
  region        = var.aws_region
  secret_key    = var.aws_secret_key
  source_ami    = var.aws_ami_id
  ssh_username  = var.ssh_username
  ami_users     = ["018471812555"]
   run_tags = {
    Name  = "Golden-AMI-${local.timestamp}"
  }
  source_ami_filter {
    filters = {
      image-id  = var.aws_ami_id
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = false
    owners      = "*"
  }
  temporary_key_pair_name = "packer-builder-{{timestamp}}"
}

