
DC = gdc -Isrc
DEBUG_FLAGS = -O0 -funittest

# Standard Targets

all: prereqs

check: bin/unittest
	bin/unittest

clean:
	rm -f bin/*
	rm -f src/dlfcn.di

# Test Objects

bin/unittest: bin/ontology.o bin/addressing.o
	$(DC) $(DEBUG_FLAGS) test/dummy.d $^ -o $@

bin/ontology.o: src/aladdin/core/ontology.d
	$(DC) -c $(DEBUG_FLAGS) $< -o $@
bin/addressing.o: src/aladdin/core/addressing.d src/aladdin/core/ontology.d
	$(DC) -c $(DEBUG_FLAGS) $< -o $@

# Prerequisites

prereqs: src/dlfcn.di


src/dlfcn.di: bin/config-dlfcn
	$^ > $@

# Executables

bin/config-dlfcn: lib/config-dlfcn.c
	$(CC) $(C_FLAGS) $^ -o $@