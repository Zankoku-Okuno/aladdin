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
 *  THIS SOFTWARE IS PROVIDED BY Okuo Zankoku "AS IS" AND ANY EXPRESS OR IMPLIED
 *  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 *  EVENT SHALL {{THE COPYRIGHT HOLDER OR CONTRIBUTORS}} BE LIABLE FOR ANY
 *  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES 
 *  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 *  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

module aladdin.core.ontology;

/*
 *  A Number is an aribtrary-precision signed integer.
 *  Publicly, Aladdin supports only this kind of number to maintatin architecture-independence.
 */
//import std.bigint : BigInt = Number;
alias long Number; //TODO

/*
 *  A label points to a named (i.e. labelled) piece of memory.
 *  Labels are relative to the environment in which they are evaluated and only access one memory level down.
 */
struct Label {
	uint id; //TODO optimize for 32- vs. 64-bit
}

/*
 *  An address is a pointer to a piece of memory.
 *  They may be relative (such as during concatenation), but are always absolute when dereferenced.
 *  There are no zero-length addresses.
 */
class Address {
private:
	Node[] data;

public:
	/* A one-level address can be constructed polymorphically from Numbers or Labels. */
	this(Number source) {
		this.data = [Node(source)];
	}
	this(Label source) {
		this.data = [Node(source)];
	}
	unittest {
		import std.stdio;
		scope(success) write('.');
		scope(failure) write('F');
		auto a = new Address(3), b = new Address(Label(4));
		assert (a.data[0].is_number);
		assert (!b.data[0].is_number);
	}
	
	/* Addresses may be appended with one another. */
	override
	Address opBinary(string s)(const Address that) const
	if (s == "~") in {
		assert (data.length > 0);
	}
	body {
		auto acc = new Address();
		acc.data = cast(Node[])(this.data ~ that.data); //UNSPIFFY why do I need the cast? a copy of a const should not be const
		return acc;
	}

	//TODO dereference

/* == OPTIMIZATIONS == */
	//used elsewhere for fast dereferencing
	override nothrow @trusted
	size_t toHash()
	in {
		assert (data.length > 0);
	}
	body{
		size_t acc = 0;
		foreach(Node x; this.data) acc = acc>>>7 + (acc^x.toHash());
		return acc;
	}

	//append a node directly instead of creating an address first
	override
	Address opBinary(string s)(Number next)
	if (s == "~") body {
		data ~= Node(next);
		return this;
	}
	override
	Address opBinary(string s)(Label next)
	if (s == "~") body {
		data ~= Node(next);
		return this;
	}

private:
	this() {}

	struct Node {
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

		nothrow @trusted
		size_t toHash() {
			return cast(size_t) (is_number ?  this.as.number : this.as.label.id);
		}

	}

}
