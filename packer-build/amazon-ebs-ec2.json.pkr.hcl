locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "ebs_backed" {
  access_key    = var.aws_access_key
  ami_name      = "packer-builder-goldenami-${local.timestamp}"
  instance_type = "t2.micro"
  region        = var.aws_region
  secret_key    = var.aws_secret_key
  source_ami    = var.aws_ami_id
  ssh_username  = var.ssh_username
   run_tags = {
    Name  = "Golden-AMI-${local.timestamp}"
  }
  
  temporary_key_pair_name = "ubuntu-packer-{{timestamp}}"
}

