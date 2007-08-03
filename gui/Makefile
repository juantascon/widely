#
# General Widely GUI Makefile
#

targets := login admin config ide
#targets := login

.DEFAULT:
	$(foreach t, $(targets), make $@ -f make/app-$(t).mk;)

all: source

.SILENT:


