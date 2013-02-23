/*
 *  ontology.d
 *  This file is part of the Aladdin virtual machine.
 *  Copyright (c) 2013, Okuno Zankoku
 *  All rights reserved. 
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions are met:
 *
 *  Redistributions of source code must retain the above copyright notice, this 
 *  list of conditions and the following disclaimer.
 *
 *  Redistributions in binary form must reproduce the above copyright notice,
 *  this list of conditions and the following disclaimer in the documentation
 *  and/or other materials provided with the distribution.
 *
 *  Neither the name of Okuno Zankoku nor the names of contributors may be used
 *  to endorse or promote products derived from this software without specific
 *  prior written permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY OKUNO ZANKOKU "AS IS" AND ANY EXPRESS OR
 *  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 *  EVENT SHALL OKUNO ZANKOKU BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
 *  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 *  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 *  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 *  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 *  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 *  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
 *  The ontology class provides the basic units of data storage in the VM.
 *  Specifically, there is the Number, an arbitrary-precision signed integer,
 *  and the Label, a scheme for naming a piece of memory and accessing it
 *  thereby.
 */
module aladdin.core.ontology;



/*
 *  A Number is an aribtrary-precision signed integer with 2s-complement semantics for logical operations.
 *  Publicly, Aladdin supports only this kind of number to maintatin architecture-independence.
 */
struct Number {
    long value;
    void* big = null;
    
    this(long i) {
        this.value = i;
    }
    this(string s) {
        import std.conv;
        try {
            this.value = parse!long(s);
        }
        catch (ConvOverflowException ex) {
            throw new Exception("TODO not implemented"); //STUB
        }
    }


    Number opBinary(string op)(const ref Number value) const {
        if (!big)
            return mixin("this.value "~op~" that.value");
        else
            throw new Exception("TODO not implemented"); //STUB
    }

    /*
    TODO if bigint is null:
        perform arithmatic on the value as normal, 
        but when done, check if the value is > 32 bits
            in which case, there's been an overflow, and we switch to bigint representation
    TODO if using bigint
        value actually stores flags (which may simply be a sign bit)
        logical operations act as if 2s-complement (could be annoying to implement)
        I'm thinking: use a dynamic array of longs
    */

    hash_t opHash() const {
        if (!big)
            return cast(hash_t) value;
        else
            throw new Exception("TODO not implemented"); //STUB
    }
    bool opEquals(const ref Number that) const {
        if (!big)
            return this.value == that.value;
        else
            throw new Exception("TODO not implemented"); //STUB

    }
    int opCmp(const ref Number that) const {
        if (!big)
            return cast(int)(this.value - that.value);
        else
            throw new Exception("TODO not implemented"); //STUB

    }

}

/*
 *  A label points to a named (i.e. labelled) piece of memory.
 *  Labels are relative to the environment in which they are evaluated and only access one memory level down.
 */
struct Label {
    uint id; //TODO optimize for 32- vs. 64-bit
    alias id this;
}





