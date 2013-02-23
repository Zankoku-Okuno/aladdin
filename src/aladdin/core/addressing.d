/*
 *  addressing.d
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
 *  This file prodives three tightly interwoven concepts: Datum, Address and
 *  MemoryCell.
 *
 *  A Datum can be either a Number of an Address.
 *
 *  A MemoryCell can contain a single Datum alongside an arbitrary number of
 *  sub-cells. 
 *
 *  An Address allows navigation in the tree of MemoryCells. An address is a
 *  list of Numbers and Labels (possibly mixed) that recursively digs into the
 *  tree of MemoryCells. Labeled MemoryCells are never numbered, and vice-versa. 
 */

module aladdin.core.addressing;

import aladdin.core.ontology : Number, Label;


/*
 *  An address is a pointer to a piece of memory.
 *  They may be relative (such as during concatenation), but are always absolute
 *  when dereferenced.
 *  There are no zero-length addresses.
 */
class Address {
private:

    /* ==================================== Fields ==================================== */

    AddressNode[] data;

    /* ==================================== Constructors ==================================== */

public:
    /* A one-level address can be constructed polymorphically from Numbers or Labels. */
    this(Number source) {
        this.data = [AddressNode(source)];
    }
    this(Label source) {
        this.data = [AddressNode(source)];
    }
    unittest {
        import std.stdio;
        scope(success) write('.');
        scope(failure) write('F');
        auto a = new Address(3), b = new Address(Label(4));
        assert (a.data[0].is_number);
        assert (!b.data[0].is_number);
    }

    private this() {}
    
    /* ==================================== Accessors ==================================== */

    /* An iterator used during dereferencing. */
    class Cursor {
    private:
        uint location;
    public:
        this(uint initial = 0) {
            this.location = initial;
        }

        Datum get(MemoryCell context) {
            auto tmp = context;
            while(location < this.outer.data.length) {
                if (!tmp) throw new Exception("TODO uninitialized");
                tmp = context[this.outer.data[location++]];
            }
            return *tmp;
        }
        void set(MemoryCell context, Datum value) {
            MemoryCell tmp = context;
            while (location < this.outer.data.length) {
                tmp = context.force(this.outer.data[location++]);
            }
            tmp = value;
        }
        
    }

    /* ==================================== Operators ==================================== */

    /* Addresses may be appended with one another. */
    Address opBinary(string s)(const Address that) const
    if (s == "~")
    in {
        assert (data.length > 0);
    }
    out (result) {
        assert (result.data.length == this.data.length + that.data.length);
        uint i;
        for(i = 0; i < this.data.length; ++i)
            assert (result.data[i] == this.data[i]);
        for( ; i < result.data.length; ++i)
            assert (result.data[i] == that.data[i-this.data.length]);
    }
    body {
        auto acc = new Address();
        //UNSPIFFY why do I need the cast? a copy of a const should not be const
        acc.data = cast(AddressNode[])(this.data ~ that.data); 
        return acc;
    }
    unittest {
        import std.stdio;
        scope(success) write('.');
        scope(failure) write('F');
        auto a = new Address(358), b = new Address(Label(0));
        auto c = a ~ b;
        c.data[1] = AddressNode(2);
        assert (!b.data[0].is_number && b.data[0].as.label == 0);
    }
    Address opBinary(string s)(Number next)
    if (s == "~") body {
        data ~= Node(next);
        return this;
    }
    Address opBinary(string s)(Label next)
    if (s == "~") body {
        data ~= Node(next);
        return this;
    }
}


private:
/* Abstraction over labels/offsets as elements of a full address. */
struct AddressNode {
    bool is_number;
    @property is_label() { return !this.is_number; }
    union U {
        Number number;
        Label label;
    };
    U as;

    this(Number source) {
        this.is_number = true;
        this.as.number = source;
    }
    this(Label source) {
        this.is_number = false;
        this.as.label = source;
    }
}

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
    MemoryCell opIndex(AddressNode index) {
        if (index.is_number)
            if (auto it = index.as.number in this.by_number) return *it;
        else
            if (auto it = index.as.label in this.by_label) return *it;
        return null;
    }
    /* As opIndex, but create and return a fresh memory cell if the index is not
    * initialized.
    */
    MemoryCell force(AddressNode index) {
        if (index.is_number)
            if (auto it = index.as.number in this.by_number) return *it;
            else return this.by_number[index.as.number] = new MemoryCell();
        else
            if (auto it = index.as.label in this.by_label) return *it;
            else return this.by_label[index.as.label] = new MemoryCell();
    }
}
