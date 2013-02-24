Aladdin
=======

Aladdin is an extensible, associative-memory-model assembly language suitable for implementation in software. While originally conceived as component of the Lotus compiler interpreter, Aladdin is designed to be useful as a drop-in module for any application that requires a custom virtual machine.

Features
========

 * Written in D for safe, fast, native execution.
 * Nested associative memory model removes the complexities of offset computation.
 * Instruction set architecture is extensible through user-written dynamic libraries.
 * Standardized D ABI allows wrapping into a number of other languages.
 * 100% branch coverage (hopefully) ensures reliability.

Requirements
============

 * D compiler -- dmd, gdc, and ldc are all good tools. I've heard dmd compiles fastest, but gdc generates the best code, but I haven't tested this myself.
 * dlfcn and a D wrapper for it -- usually comes with a *NIX system

Install
=======

Right now, the makefile is very limited: it's really only instrumented for gdc, and only produces debug/testing output.

Building
--------
Environment
-----------

Project State
=============

Aladdin is in its very early stages right no, so not much is working. I'm pleased to report that the data memory side of the architecture is essentially finished. On the other hand, bigints are not yet supported, and many ALU operations are not implemented (none are tested), which makes the data memory much less useful.

Up next is getting the text memory side working. After that, I should be able to look at loading some microcode and executing the machine. With that "main loop" stuff out of the way, I'll be able to focus on fleshing out the ALU and performing optimizations.

Finished
--------

* Address data type
* Small integer support (limited operations)
* Data memory structure & addressing

In Progress
-----------

 * Text memory structure
 * Decode/execute
 * Microcode loading
 * Machine main loop
 * Interface to the machine for microcode
 * More operations on integer type
 * Support the bigint data type (the D library's version looks unusable: I've already wasted two hours on it)
 * Cache shortcuts to memory addresses
 * Standard library of operations

Future Work
-----------

 * Make dynamic library loading less dependent on POSIX.
 * Make build process more easily configurable and portable.
 * Autoconf support
 * Unicode string extension, multi-processing extension

