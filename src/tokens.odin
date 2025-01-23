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
TOKEN_IMPORT :: "#include "

TOKEN_ROTFILE :: ".rot\""
TOKEN_ROTHEADER :: ".rh\""
TOKEN_CFILE :: ".c\""
TOKEN_CHEADER :: ".h\""

// --- Variables ---
@(private="file")
is_string : bool

// --- Procedures ---
parse_row :: proc(line : string, alloc := context.allocator) -> string {

    if strings.contains(line, TOKEN_SKIP) {
        preline := line // preprocessor line

        // Convert .rot to .c and .rh to .h
        if strings.starts_with(line, TOKEN_IMPORT) {
            if strings.ends_with(line, TOKEN_ROTFILE) {
                preline, _ = strings.replace(
                    preline, TOKEN_ROTFILE,
                    TOKEN_CFILE, 1, alloc
                )
            } else if strings.ends_with(line, TOKEN_ROTHEADER) {
                preline, _ = strings.replace(
                    preline, TOKEN_ROTHEADER,
                    TOKEN_CHEADER, 1, alloc
                )
            }
        }

        return preline
    }
    temp_parse := ""

    // Remove single line comments
    no_single_com := strings.split_after(line, TOKEN_COMMENT, alloc)[0]
    temp_parse = no_single_com
    /* Can't bother multiline comments now, add later! */

    // Loop them with fanum tax
    temp_parse = fanum_tax(temp_parse, alloc)

    // Find strings
    split := strings.split(temp_parse, TOKEN_STRING, alloc)
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

fanum_tax :: proc(line : string, alloc := context.allocator) -> string {
    // A fanum tax loop is given with the following format
    //   fanum tax (variant; range)
    // where variant is a valid rot type variable
    // and range is of type
    //   a..=b | [a, b] or a..<b | [a, b)
    // The expression gets translated into
    // fanum (variant = a; variant CMP b; variant += 1)

    TOKEN_FT :: "fanum tax"
    TOKEN_LE :: "..="
    TOKEN_L  :: "..<"
    if !strings.contains(line, TOKEN_FT) do return line

    // Get loop type
    range_contains := strings.contains(line, TOKEN_LE)
    range := strings.contains(line, TOKEN_L)

    if !(range_contains ~ range) do return line

    // Split line to parts
    split, _ := strings.split(line, TOKEN_FT, alloc)
    pre   := split[0]
    post  := split[1]
    token := range ? TOKEN_L : TOKEN_LE

    // Split post part to parts
    a, b : string
    post_split,  _ := strings.split(post, token, alloc)
    if !strings.contains(post_split[0], "(") do return line // You need brackets!
    if !strings.contains(post_split[1], ")") do return line // You need brackets!

    // Get 'b' value and line end
    split_right, _ := strings.split(post_split[1], ")", alloc)
    b = split_right[0]
    line_end := split_right[1]
    
    // Get variant and 'a' value
    variant : string
    if !strings.contains(post_split[0], ";") do return line // You need a semicolon!
    split_left, _ := strings.split(post_split[0], ";", alloc)
    a, _ = strings.replace_all(split_left[1], " ", "", alloc)
    variant, _ = strings.replace(split_left[0], "(", "", 1, alloc)
    variant = strings.trim_space(variant) // Trim extra spaces
    varname := strings.split(variant, " ", alloc)[max(strings.count(variant, " "), 0)]

    // Combine into proper expression
    comparison := range ? "<" : "<="
    return fmt.tprintf(
        "%sfor (%s = %s; %s %s %s; %s += 1)%s",
        pre, variant, a, varname, comparison, b, varname, line_end
    )
}


is_keyword :: proc(token : string) -> bool {
    for t in KEYS_ROT {
        if t == token do return true
    }
    return false
}