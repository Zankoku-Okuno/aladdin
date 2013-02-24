import aladdin.core.code : Operation;

struct SyntaxValidator {
    size_t lower_bound;
    size_t upper_bound;
}

Operation[string] opcodes;
OperationInfo[Operation] reverse_lookup;


struct OperationInfo {
    string opname;
    Operation opcode;
    SyntaxValidator validator;
    //TODO track what library it was loaded from
}


private struct Registry {
    //TODO load extensions
    //TODO load/return opcodes on request by name
    //TODO track OperationInfos
    //TODO track what extensions have been loaded from
    //TODO unload unused extensions
}