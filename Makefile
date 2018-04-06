.PHONY: autoformat validate check-format

autoformat:
	terraform fmt

validate:
	find . -type f -name "*.tf" -exec dirname {} \; | sort -u | while read m; do \
		echo -n "Checking '$$m': "; \
		(terraform validate -check-variables=false "$$m" && echo "√") || exit 1 ; \
	done

check-format:
	find . -type f -name "*.tf" -exec dirname {} \; | sort -u | while read m; do \
		echo -n "Checking '$$m': "; \
		(terraform fmt -write=false --diff=true --check=true "$$m" && echo "√") || exit 1 ; \
	done
