Aladdin
=======

Aladdin is a cross-platform optimizing assembler.
That sounds strange, so let's look at what it really means.

Aladdin can be targeted to different machine architectures by defining
different machine models (sets of registers and operations given meaning
in an agnostic micro-operation language).
So, the Aladdin engine can assemble to many machines, but any single source
file might be platform-specific.

Basic blocks in Aladdin are typed with what registers are live, the 
transformation on the stack shape, and what registers are clobbered.
This not only allows type checking, but it is also the bulk of a calling
convention.
A calling convention allows to map from a list of arguments to one of
these basic block types.
Labels (both internal/defined and external/declared-only) can be given
a calling convention, and any calls to that label will automatically
arrange for local context to be stored and arguments to be passed.
Aladdin can even do tail-calls automatically.
Finally, we can take advantage of the calling convention rules to have
an easy FFI, such as to system calls.

When you don't need a particular register, you can tell the assembler to
allocate one for you under a fresh name.
If spillover needs to happen, Aladdin can also handle that automatically
instead of just failing to allocate.
This works a bit like manual memory management, so you'll have to free the
register when you're done with it.
However, Aladin also uses a static semantics to detect what registers are
allocated at basic block boundaries, so you'll know when you've messed up.

Addressing modes are complex and architecture-dependent.
The Aladdin micro-op semantics only offer register, immediate and computed 
address modes.
Computed addresses can be found with any arithmetic expression, but if we
can't find a native addressing mode to handle it, we'll generate additional
computational code.
We also warn you, so you'll know when you might be sacrificing performance.

Aladdin knows the simplification rules for micro-ops all operations are
defined in.
Thus, Aladdin may be able to find algebraic simplifications of your code
by looking at a lower level of abstraction.
We don't do very fancy things here, really just stuff inside basic blocks,
and some analysis between basic blocks to do register allocation in a
performance-conducive way.
Fancier optimizations, like loop optimizations or tail-call optimizations
should be done at a higher-level language, where the relationships between
data are clearer.


Project Status
==============

Well, that's the idea, but it'll take some time to implement.
With everything I've got going on, I don't expect anything production-ready
until about 2020.
Part of the problem is that I want to have a serious formal design,
and another is that I need to be more familiar with assembly itself.

