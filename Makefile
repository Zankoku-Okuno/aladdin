
# Standard Targets

all: prereqs

clean:
	-rm bin/*
	-rm src/dlfcn.di

# Prerequisites

prereqs: src/dlfcn.di


src/dlfcn.di: bin/config-dlfcn
	$^ > $@

# Executables

bin/config-dlfcn: lib/config-dlfcn.c
	$(CC) $(C_FLAGS) $^ -o $@