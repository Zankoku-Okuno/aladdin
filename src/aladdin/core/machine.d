/*
 *  machine.d
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
 * This file contains only the AladdinMachine class, which unifies all the
 * storage and control components of the Aladdin Virtual Machine into a clean
 * interface.
 *
 * The control component of the VM exposes only methods to update the
 * instruction pointer. All other control is interior, but implemented here.
 *
 * The instruction and data memories are strictly separated. Allowing data-
 * driven modification of the code would complicate the data model beyond
 * reasonable limits. TODO In the future, support for dynamic loading, including
 * JIT compiling, may be supported.
 *
 * In case anyone was wondering where the ALU and I/O components of the VM are,
 * they have been delegated away. The ALU is accessed through the Datum class,
 * and no I/O operations are even directly considered for the VM. Plugins can
 * provide arbitrary code, such as serialization, communication with other
 * hardware, or even new data types and operations: in short, plugins are meant
 * to extend the VM's ALU and I/O capabilities, and possibly add new locations
 * and types of data storage.
 */

module aladdin.core.machine;

import aladdin.core.addressing : Address, MemoryCell;
import aladdin.core.code : TextMemory;


class AladdinMachine { //STUB
private:
    size_t ip;
    TextMemory text;
    MemoryCell data;
}