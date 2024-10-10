terraform {
  required_version = ">= 0.13"

  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.1"
    }
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_volume" "vm_disk" {
  name   = "${var.vm_name}-disk"
  pool   = "default"
  source = "/var/lib/libvirt/images/rhel9.2.qcow2"
  format = "qcow2"
##  size   = var.disk_size * 1024 * 1024 * 1024 # Convert GB to bytes
}

resource "libvirt_domain" "vm" {
  name   = var.vm_name
  memory = var.memory
  vcpu   = var.vcpus

   cpu {
    mode = "host-passthrough" # Directly pass through the host's CPU capabilities to the VM
  }

  firmware = "/usr/share/OVMF/OVMF_CODE_4M.fd"
  nvram {
    file = "/var/lib/libvirt/qemu/nvram/${var.vm_name}_VARS.fd"
  }

  boot_device {
    dev = ["cdrom", "hd"]
  }

  disk {
    volume_id = libvirt_volume.vm_disk.id
    scsi      = true
  }

  network_interface {
    network_name = "default"
  }


  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  graphics {
    type        = "spice"
    listen_type = "none"
  }
}

