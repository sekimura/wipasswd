TARGET = x86_64-apple-macosx10.10
SDK = $$(xcrun --show-sdk-path --sdk macosx)

all: wipasswd

wipasswd: wipasswd.swift
	@xcrun swiftc -sdk ${SDK} -target ${TARGET} -o wipasswd wipasswd.swift
	@touch $@

clean:
	@rm -rf wipasswd

.PHONY: clean
