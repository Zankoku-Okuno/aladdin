import std.stdio;
import core.exception;
import core.sys.posix.unistd : exit = _exit; //HAX seems like there should already be a platform-independent facade

void main(string[] args) {
    writefln("========================================================================================");
    writefln("Mesdames, messieurs, bon soir!");
    writefln("========================================================================================");
    scope(exit) {
        report();
        exit(cast(int) num_problems());
    }
}

void run_test(void delegate() block) {
    queued_tests ~= block;
}

void report() {
    run_impl();
    writefln("========================================================================================");
    foreach(AssertError ex; failures) writeln(ex);
    foreach(Exception ex; errors) writeln(ex);
    writefln("========================================================================================");
    writefln("Ran %d tests (%d failures).", tests, num_problems() );
    writeln(num_problems() ? "FAILURE" : "OK");
    writefln("========================================================================================");
}

private:
uint tests = 0;

void delegate()[] queued_tests;
AssertError[] failures;
Exception[] errors;

size_t num_problems() {
    return failures.length + errors.length;
}

void run_impl() {
    foreach (void delegate() t; queued_tests)
        try {
            ++tests;
            scope(success) write('.');
            scope(failure) write('F');
            t();
        }
        catch (AssertError ex) { failures ~= ex; }
        catch (Exception ex) { errors ~= ex; }
    writeln();
}