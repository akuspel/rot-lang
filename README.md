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

## Compiling
You can choose to compile with the given command line tool, where you can define your own preferred compiler with `rot build path -out=compiler`.
If none is given, the default compiler is g++.

You can also just translate the file to c with `rot trans path`.

## Example
A simple example using rot-lang, which can also be found in `demo/demo.rot`.
```cpp
#include "stdio.h"

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
    printf("Noooo\n");
}

// --- Main Program ---
int main() {

    printf("mogger gets mogged\n");
    fanum (int i = 0; i < 12; i += 1) {

        so (i == 11) {
            bust; // a nut
        } what {
            printf("%i", i);
        }
    }

    /* Begin the Goon Sesh */
    printf("\nI'm about to goon!\n");
    int gooning = 0;
    goon {
        gooning += 1;
        Person p = {
            .gooner = (quirky int) gooning % 3,
            .name = "Man",
            .rizz = 0.0,
        };
        if (is_gooner(p)) printf("Person %i, is a gooner!\n", gooning);

    } tax (gooning < 10);
    printf("Gooned for %i seconds :0\n", gooning);

    /* No more Gooning, thanks! */
    amogus("Red is very sus (amogus)");

    rizzup 0;
}
```

## Dependencies
To compile the compiler, you need the odin compiler from odin-lang.org.
To use the compiler to its full extent, you need a c / c++ compiler of your choice.
