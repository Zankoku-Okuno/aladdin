module aladdin.core.ontology;


//import std.bigint : BigInt;
alias long BigInt; //TODO

/*
 * A label points to a named (i.e. labelled) piece of memory.
 * Labels are relative to the environment in which they are evaluated and only access one memory level down.
 */
struct Label {
	int id;
}

/*
 * An address is a pointer to a piece of memory.
 * They may be relative (such as during concatenation), but are always absolute when dereferenced.
 * There are no zero-length addresses.
 */
class Address {

	Node[] data;

	Address opBinary(const Address that) const 
	in {
		assert (data.length > 0);
	}
	body {
		auto acc = new Address();
		acc.data = cast(Node[])(this.data ~ that.data); //UNSPIFFY why do I need the cast? a copy of a const should not be const
		return acc;
	}

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

private:
	this() {}

	struct Node {
		bool is_number;
		@property is_label() { return !this.is_number; }
		union U {
			BigInt number;
			Label label;
		};
		U as;

		nothrow @trusted
		size_t toHash() {
			return cast(size_t) (is_number ?  this.as.number : this.as.label.id);
		}

	}

	//TODO
	//how to construct from code?

}

/*
 * A datum is the fundamental data type of the virtual machine.
 * Data may be either a single arbitrary-precision integer or address.
 */
struct Datum {

	bool is_number;
	@property bool is_address() { return !is_number; }

	private union U {
		BigInt number;
		Address address;
	}
	U as;


	this(BigInt value) {
		this.as.number = value;
		this.is_number = true;
	}
	this(Address value) {
		this.as.address = value;
		this.is_number = false;
	}
}

/*
 * MemoryCells are responsible for tracking all data in the application.
 * Each cell of memory can store a datum (integer of address).
 * With each memory is associated two sub-memories: an array and a set of labeled memories.
 */
struct MemoryCell {
	Datum datum;
	MemoryCell*[int] ordered;
	MemoryCell*[Label] address;
}



