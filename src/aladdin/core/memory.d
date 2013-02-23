/*
 *  memory.d
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
 *  This module provides an interface to the Aladdin memory model.
 *  Specifically, it provides a) an abstraction over integers and addresses
 *  called a 'Datum' and b) a 'MemoryCell' class, which is the fundamental unit
 *  of memory organization in the virtual machine.
 */
module aladdin.core.memory;

import aladdin.core.ontology;

/*
 * A datum is the fundamental data type of the virtual machine.
 * Data may be either a single arbitrary-precision integer or address.
 */
class Datum {
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
 * MemoryCells are responsible for tracking all data in the application.
 * Each cell of memory can store a datum (integer of address).
 * With each memory is associated two sub-memories: an array and a set of labeled memories.
 */
class MemoryCell {
private:
    Datum datum = null;
    MemoryCell[Number] by_number;
    MemoryCell[Label] by_label;
public:
    /* Dereference: get the datum stored here, if initialized. */
    Datum opUnary(string op)() if (op == "*") {
        return this.datum;
    }
    MemoryCell opAssign(Datum value) {
        this.datum = value;
        return this;
    }
    /* Polymorphically access submemories by either number or label.
     * Returns null if the index is not yet initialized.
     */
    MemoryCell opIndex(Number index) {
        if (auto it = index in this.by_number) return *it;
        else return null;
    }
    MemoryCell opIndex(Label index) {
        if (auto it = index in this.by_label) return *it;
        else return null;
    }
}