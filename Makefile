.PHONY: autoformat validate check-format

autoformat:
	terraform fmt


validate:
	find . -type f -name "*.tf" -exec dirname {} \; | sort -u | grep -v ".terraform" | while read m; do \
		echo -n "Checking '$$m': "; \
		( \
			cd "$$m" && \
			terraform init -backend=false -input=false > /dev/null && \
			terraform validate -var-file test.tfvars && \
			echo "√" \
		) || exit 1 ; \
	done

check-format:
	if ! terraform fmt --check --diff; then \
		echo "Some terraform files need be formatted, run 'make autoformat' to fix"; \
		exit 1; \
	else \
		echo "OK"; \
	fi

setup-git-hook: .git/hooks/pre-commit
.git/hooks/pre-commit:
	echo "#!/bin/sh" > $@
	echo "terraform fmt | xargs git add" >> $@
	chmod +x $@
