= Interfaces

Test suite for testing interfaces against different
language.

== Idea

The core idea about this testing suite is to start
testing an interface with a "zero" state. This means
all tests start at a well defined state all manipulation
on the data that lie behind the interface have to be done
trought the interface.

By doing so, knowledge about the underlying architecture
is needed, and different implementations can be tested
with the same tests.

Minimum rules:
 * A interface may only be tested trough interface functions
 * There may be functions in the interface dedicated for testing
 * No other data may be processed by the interface than those given trough interface calls

== Interface

For simplicity a interface can only be tested trough ruby functions.
To test native code a ruby bridge must be implemented and
the test suite tests then tests the bridge code and the interface
together.

 * Functions
 * State

== Supported objects

 * Number (Float/Natural)
 * String
 * Null
 * Array
 * Hash
 * DateTime

== Function types

 * Read (Only read data from state)
 * Write (Only changes state but no information about state is returned)
 * ReadWrite (Writes and reads state)
 * Pure (Does not read or write anything)

