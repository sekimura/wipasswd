SDK = $$(xcrun --show-sdk-path --sdk macosx)

all: wipasswd

wipasswd: wipasswd.swift
	@xcrun swiftc -sdk $(SDK) -o wipasswd wipasswd.swift
	@touch $@

clean:
	@rm -rf wipasswd

.PHONY: clean
