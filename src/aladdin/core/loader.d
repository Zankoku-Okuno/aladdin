/*
 *  loader.d
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

/* DOC */

//TODO three things are really going on:
//      load extensions
//      loading aladdin assembly code (parse/verify, store in TextMemory)
//      linking aladdin assemblies (simply joining TextMemories togeter)
// let's analyze the life cycles of the data structures needed here

//TODO consider what happens when two assembly files define the same name
//      I say, this should be detected and treated as error. this way, addresses in one assembly can reference external assemblies

module aladdin.core.loader;

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