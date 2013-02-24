/*
 *  errors.d
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
 *  This file provides the exceptions used by Aladdin.
 *
 *  The hierarchy is roughly as follows: AladdinRuntimeErrors are raised by the
 *  virtual machine in response to some inappropriate client code (such as
 *  dereferencing uninit'd memory, attempting illegal operations, &c.). All
 *  other Aladdin-detected errors go through the AladdinException class. These
 *  include syntax errors or microcode loading errors.
 *
 *  If there is an internal error in Aladdin, then those errors will not
 *  subclass AlladinException, so they may be distinguished from user errors.
 */

module aladdin.core.errors;

//DOC
class AladdinException : Exception {
    this(string msg, string file, ulong line, Throwable next = null) {
        super(msg, file, line, next);
    }
}

//DOC
class AladdinRuntimeError : AladdinException {
    this(string msg, string file, ulong line, Throwable next = null) {
        super(msg, file, line, next);
    }
}

//DOC
class UninitializedMemory : AladdinRuntimeError {
    this(string file, ulong line, Throwable next = null) {
        super("Attempted to read uninitialized memory.", file, line, next);
    }
}