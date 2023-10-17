.PHONY: pulumi
pulumi:
	pulumi -C pulumi/sandbox up -yrf

.PHONY: ansible
ansible: inventory playbook

.PHONY: inventory
inventory: 
	pulumi -C pulumi/sandbox stack output ansibleInventory > ansible/inventories/$(shell pulumi -C pulumi/sandbox stack --show-name).yml

.PHONY: playbook
playbook: 
	ansible-playbook ansible/playbook.yml -i ansible/inventories/$(shell pulumi -C pulumi/sandbox stack --show-name).yml

up: pulumi inventory playbook

.PHONY: down
down:
	pulumi -C pulumi/sandbox destroy -yrf
	pulumi -C pulumi/eks destroy -yrf

.PHONY: test
test:
	ansible-playbook test/test-docker.yml -i ansible/inventories/$(shell pulumi -C pulumi/sandbox stack --show-name).yml

.PHONY: test-k3s
test-k3s:
	ansible-playbook test/test-k3s.yml -i ansible/inventories/$(shell pulumi -C pulumi/sandbox stack --show-name).yml

.PHONY: k8s
k8s: 
	pulumi -C pulumi/eks up -yfr

.PHONY: kubeconfig
kubeconfig: 
	pulumi -C pulumi/eks stack output kubeconfig > kubeconfig