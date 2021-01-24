ifndef WORKSPACE
$(error WORKSPACE is not set)
endif

ifndef PATH
$(error WORKSPACE is not set)
endif

.PHONY: all plan apply destroy

all: plan

plan:
	cd $(PATH) && \
	/usr/local/bin/terraform init -no-color && /usr/local/bin/terraform workspace select $(WORKSPACE) || /usr/local/bin/terraform workspace new $(WORKSPACE) && \
	/usr/local/bin/terraform plan

apply:
	cd $(PATH) && \
	/usr/local/bin/terraform workspace select $(WORKSPACE) && \
	/usr/local/bin/terraform apply

destroy:
	cd $(PATH) && \
	/usr/local/bin/terraform workspace select $(WORKSPACE) && \
	/usr/local/bin/terraform destroy
