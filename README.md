 # Aladdin #

Aladdin is an extensible, associative-memory-model assempbly language suitable for implementation in software. While originally conceived as component of the Lotus compiler interpreter, Aladdin is designed to be usefule as a drop-in module for any application that requires a custom virtual machine.

 ## Features ##

 * Written in D for safe, fast, native execution.
 * Nested associative memory model removes the complexities of offset computation.
 * Instruction set architecture is extensible through user-written dynamic libraries.
 * Standardized D ABI allows wrapping into a number of other languages.
 * 100% branch coverage (hopefully) ensures reliability.

 ## Requirements ##

* D compiler
* Dynamic Libraries for D:
	one of my own projects to bring dynamic linking to D. currently, the library only supports glibc-compatible dlfcn.h, so you're also limited to UNIX

 ## Install ##

 ### Building ###
 ### Environment ###

 ## Project State ##
 
 ### Finished ###
 ### Working ###

 ### Future Work ###

 * Make dynamic library loading less dependent on glibc and POSIX.
 * Make build process more easily comfigurable and portable.

