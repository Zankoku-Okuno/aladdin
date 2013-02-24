import aladdin.core.addressing : Datum, Address;

alias Operation void function(Datum[]);

struct Instruction {
    Operation operation;
    Datum[] operands;
}

class TextMemory {
    Instruction[] text;

    size_t[Address] jump_targets;
}