package rotcom

/* --- Rot Language Compiler Token definitions ---
 * 
 *
 */

import "core:fmt"
import "core:strings"


// --- Types ---
KeyWord :: enum {
    IF,
    ELSE,

    FOR,
    WHILE,
    DO,
    GOTO,

    SWITCH,
    BREAK,
    CONTINUE,
    DEFAULT,
    CASE,
    RETURN,

    // Variable Types
    INT,
    BOOL,
    FLOAT,
    LONG,
    SHORT,
    DOUBLE,
    ENUM,
    STRUCT,
    UNION,
    VOID,
    CHAR,

    NULLPTR,

    // Status
    AUTO,
    UNSIGNED,
    CONST,
    VOLATILE,
    INLINE,
    EXTERN,

    TYPEDEF

}

// --- Constants ---
KEYS_C := [KeyWord]string {
    .IF = "if",
    .ELSE = "else",

    .FOR = "for",
    .WHILE = "while",
    .DO = "do",
    .GOTO = "goto",

    .SWITCH = "switch",
    .BREAK = "break",
    .CONTINUE = "continue",
    .DEFAULT = "default",
    .CASE = "case",
    .RETURN = "return",

    .INT = "int",
    .BOOL = "bool",
    .FLOAT = "float",
    .LONG = "long",
    .SHORT = "short",
    .DOUBLE = "double",
    .ENUM = "enum",
    .STRUCT = "struct",
    .UNION = "union",
    .VOID = "void",
    .CHAR = "char",

    .NULLPTR = "nullptr",

    .AUTO = "auto",
    .UNSIGNED = "unsigned",
    .CONST = "const",
    .VOLATILE = "volatile",
    .INLINE = "inline",
    .EXTERN = "extern",

    .TYPEDEF = "typedef",
}

KEYS_ROT := [KeyWord]string {
    .IF = "so",
    .ELSE = "what",

    .FOR = "fanum",
    .WHILE = "tax",
    .DO = "goon",
    .GOTO = "cope",

    .SWITCH = "stream",
    .BREAK = "bust",
    .CONTINUE = "edge",
    .DEFAULT = "noskin",
    .CASE = "caseoh",
    .RETURN = "rizzup",

    .INT = "int",
    .BOOL = "fact",
    .FLOAT = "float",
    .LONG = "shlong",
    .SHORT = "short",
    .DOUBLE = "double",
    .ENUM = "enum",
    .STRUCT = "skibidi",
    .UNION = "gang",
    .VOID = "sus",
    .CHAR = "word",

    .NULLPTR = "wrong",

    .AUTO = "gyatt",
    .UNSIGNED = "quirky",
    .CONST = "sigma",
    .VOLATILE = "tweaking",
    .INLINE = "core",
    .EXTERN = "alien",

    .TYPEDEF = "looksmax",
}

when ODIN_OS == .Windows {
    TOKEN_NEWLINE :: "\r\n"
} else {
    TOKEN_NEWLINE :: "\n"
}


TOKEN_SEPARATOR :: [?]string {
    " ", ";"
}

TOKEN_COMMENT_BEGIN :: "/*"
TOKEN_COMMENT_END :: "*/"
TOKEN_COMMENT :: "//"

TOKEN_SKIP :: "#"

TOKENS_ALLOWED :: ""

TOKEN_STRING :: "\""

// --- Variables ---
@(private="file")
is_string : bool

// --- Procedures ---
parse_row :: proc(line : string, alloc := context.allocator) -> string {

    if strings.contains(line, TOKEN_SKIP) do return line

    // Remove single line comments
    no_single_com := strings.split_after(line, TOKEN_COMMENT, alloc)[0]
    /* Can't bother multiline comments now, add later! */

    // Find strings
    split := strings.split(no_single_com, TOKEN_STRING, alloc)
    changes := len(split) > 1

    if changes do is_string = !is_string // Flip 
    for &s, i in split {
        if changes do is_string = !is_string
        
        parsed := s
        if !is_string {
            for key in KeyWord {
                key_rot := KEYS_ROT[key]
                key_c   := KEYS_C[key]
                
                err : bool
                parsed, err = strings.replace_all(parsed, key_rot, key_c, alloc)
            }
        }
        
        s = i == 0 ? parsed : strings.concatenate({TOKEN_STRING, parsed}, alloc)
    }

    return strings.concatenate(split, alloc)
}


key_replace :: proc(line : string, key : KeyWord, alloc := context.allocator) -> (string, bool) {




    return line, false
}