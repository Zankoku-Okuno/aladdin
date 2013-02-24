
DC = gdc -Isrc
DEBUG_FLAGS = -O0 -funittest

# Standard Targets

all: prereqs

check: bin/unittest
	bin/unittest

clean:
	rm -f bin/unittest
	rm -f bin/*.o
	rm -f bin/debug/*.o
	rm -f src/dlfcn.di

# Test Objects

bin/debug/errors.o: src/aladdin/core/errors.d
	$(DC) -c $(DEBUG_FLAGS) $< -o $@

bin/debug/ontology.o: src/aladdin/core/ontology.d
	$(DC) -c $(DEBUG_FLAGS) $< -o $@
bin/debug/addressing.o: src/aladdin/core/addressing.d src/aladdin/core/ontology.d src/aladdin/core/errors.d
	$(DC) -c $(DEBUG_FLAGS) $< -o $@

# Prerequisites

prereqs: src/dlfcn.di


src/dlfcn.di: bin/config-dlfcn
	$^ > $@

# Executables

bin/unittest: bin/debug/ontology.o bin/debug/addressing.o bin/debug/errors.o test/framework.d
	$(DC) $(DEBUG_FLAGS) $^ -o $@

bin/config-dlfcn: lib/config-dlfcn.c
	$(CC) $(C_FLAGS) $^ -o $@