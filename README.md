#This is how I used Terraform to create new vms based on a clean rhel9 installation.


#Use snapshot
virsh snapshot-create-as --domain rhel9.2 --name golden-template --description "Snapshot of golden template"

#Or shutdown and copy the vm

 terraform init
 terraform plan -var="vm_name=aap11emc6" -var="memory=2048" -var="vcpus=2"
 terraform apply


