
autoformat:
	terraform fmt

validate:
	find . -type f -name "*.tf" -exec dirname {} \; | sort -u | while read m; do \
		echo -n "Checking '$$m': "; \
		(terraform validate -check-variables=false "$$m" && echo "√") || exit 1 ; \
	done

check-format:
	if [[ -n "$(terraform fmt -write=false)" ]]; then \
		echo "Some terraform files need be formatted, run 'terraform fmt' to fix"; \
		exit 1; \
	else \
		echo "OK"; \
	fi

lint:
	tflint
