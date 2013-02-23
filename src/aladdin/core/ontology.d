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
 *  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;LOSS OF USE, DATA, OR PROFITS;
 *  OR BUSINESS INTERRUPTION) HOWEVER CAUSED ANDON ANY THEORY OF LIABILITY,
 *  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT(INCLUDING NEGLIGENCE OR
 *  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OFTHIS SOFTWARE, EVEN IF
 *  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
 *  The ontology class provides the basic units of data storage in the VM.
 *  Specifically, there is the Number, an arbitrary-precision signed integer,
 *  and the Label, a scheme for naming a piece of memory and accessing it
 *  thereby. 
 *
 *  More importatly, this file provides the Datum struct, which provides an
 *  abstraction over the Number and Label types, so that either may be stored in
 *  a piece of memory.
 */
module aladdin.core.ontology;

/*
 * A datum is the fundamental data type of the virtual machine.
 * Data may be either a single arbitrary-precision integer or address.
 */
class Datum {
    import aladdin.core.addressing : Address;
private:
    bool is_number;
    @property bool is_address() { return !is_number; }

    union U {
        Number number;
        Address address;
    }
    U as;

public:
    this(Number value) {
        this.as.number = value;
        this.is_number = true;
    }
    this(Address value) {
        this.as.address = value;
        this.is_number = false;
    }

    //TODO support all the operations on data in here, including doing the typechecking.
    //addresses can be concated, dereferenced
    //numbers can be arithemtic(+-*/%) compare(<>=) logicals(&|^!)?
    //there are no operations between addresses and numbers
}

/*
 *  A Number is an aribtrary-precision signed integer.
 *  Publicly, Aladdin supports only this kind of number to maintatin architecture-independence.
 */
//import std.bigint : BigInt = Number;
alias long Number; //STUB

/*
 *  A label points to a named (i.e. labelled) piece of memory.
 *  Labels are relative to the environment in which they are evaluated and only access one memory level down.
 */
struct Label {
    uint id; //TODO optimize for 32- vs. 64-bit
    alias id this;
}





