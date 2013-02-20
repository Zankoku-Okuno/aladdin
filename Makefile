
# Standard Targets

all: prereqs

check: src/aladdin/core/ontology.d
	gdc -Isrc -funittest test/dummy.d $^ -o unittest
	./unittest

clean:
	-rm bin/*
	-rm src/dlfcn.di
	-rm ./a.out

# Prerequisites

prereqs: src/dlfcn.di


src/dlfcn.di: bin/config-dlfcn
	$^ > $@

# Executables

bin/config-dlfcn: lib/config-dlfcn.c
	$(CC) $(C_FLAGS) $^ -o $@