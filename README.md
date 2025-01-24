# Rot-Lang, the Brainrot Programming Language
Are you tired of writing boring old c?
Wish to make your brainrot infection worse while coding?
!!! rot-lang may be the solution for you !!!
## Rot what?
rot-lang is a translated language, which produces C-code from your brainrot.
The syntax is exactly like c, with the following key words replaced:

| C   | rot-lang |
| ----- | ----- |
| if | so |
| else | what |
|  |  |
| for | fanum |
| while | tax |
| do | goon |
| goto | cope |
|  |  |
| switch | stream |
| break | bust |
| continue | edge |
| default | noskin |
| case | caseoh |
| return | rizzup |
|  |  |
| int | int |
| bool | fact |
| float | float |
| long | shlong |
| short | short |
| double | double |
| enum | enum |
| struct | skibidi |
| union | gang |
| void | sus |
| char | word |
|  |  |
| nullptr | wrong |
|  |  |
| auto | gyatt |
| unsigned | quirky |
| const | sigma |
| volatile | tweaking |
| inline | core |
| extern | alien |
|  |  |
| typedef | looksmax |

Some common functions also have replaced names, currently these include:
- **malloc** : mew
- **printf** : spit

## Compiling
You can choose to compile with the given command line tool, where you can define your own preferred compiler with `rot build path -out=compiler`.
If none is given, the default compiler is g++.

You can also just translate the file to c with `rot trans path`.

### Rot Build System
Introduced in version 0.02, the Rot Build System allows for *easy* and *simple* project build setup with the rot-build filetype (.rb).

A .rb is a text document, where each row is a single command. The following commands are supported currently:
- **.com** : sets the compiler to the value specified after
- **.trans** : translates the provided file path to c
- **.build** : translates and builds the provided file path, can be given following command line arguments
To then run the build file, one does `rot build __path_to_buildfile__.rb`
  
With this system, you can `#include` other .rot files, and have it all compile correctly.
Beneath is an example from `demo/demo.rb`:
```rb
.com g++

.trans rot.rot
.build demo.rot -o skibidi.exe
```

## Example
A simple example using rot-lang, which can also be found in `demo/demo.rot`. Following the addition of a build system, the demo must now be built with `rot build demo.rb`.
```cpp
#include "stdio.rh"
#include "rot.rot"

#define MOGGER_GETS_MOGGED 1
#define FAX 1
#define FAKE_NEWS 0

// --- Types ---
looksmax skibidi {
    quirky int gooner;
    sigma word* name;
    float rizz;
} Person;

// --- Constants ---
sigma shlong frank = 420.0;

// --- Procedures ---
int is_gooner(Person person) {
    rizzup person.gooner == FAX;
}

sus amogus(sigma word* frick) {
    gyatt maxx = frick;
    spit("Nooooes\n");
}

// --- Main Program ---
int main() {

    spit("mogger gets mogged\n");
    fanum (int i = 0; i < 12; i += 1) {

        so (i == 11) {
            bust; // a nut
        } what {
            spit("%i", i);
        }
    }

    /* Begin the Goon Sesh */
    spit("\n\nI'm about to goon!\n");
    int gooning = 0;
    goon {
        gooning += 1;
        Person p = {
            .gooner = (quirky int) gooning % 3,
            .name = "Man",
            .rizz = 0.0,
        };
        if (is_gooner(p)) spit("Person %i, is a gooner!\n", gooning);

    } tax (gooning < 10);
    spit("Gooned for %i seconds :0\n\n", gooning);

    /* No more Gooning, thanks! */
    amogus("Red is very sus (amogus)");

    /* Fanum tax collection */
    int rom = 10;
    fanum tax (int i; 0..=rom + 1) {
        int x = i;
        mogger(&x);
        spit("fanum tax: %i | %i\n", i, x);
    }
    spit("\n");

    /* Demented Array! */
    gyatt arr = array_init(sizeof(int));
    array_resize(&arr, 10);
    *(int*)array_at(&arr, 4) = 5;
    array_print(arr, int);

    rizzup 0;
}
```

## Dependencies
To compile the compiler, you need the odin compiler from odin-lang.org.
To use the compiler to its full extent, you need a c / c++ compiler of your choice.
