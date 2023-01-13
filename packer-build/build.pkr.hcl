build {
  sources = ["source.amazon-ebs.ebs_backed"]

  provisioner "shell" {
    script = "./packer-build/provision-script.sh"
  }

}
