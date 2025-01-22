package rotcom

import "core:os"
import "core:fmt"
import "core:strings"
import "core:c/libc"

ROT_VERSION :: "0.01 - a"

CommandProc :: proc(args : []string) -> bool

commands := map[string]CommandProc {
    "help" = proc(args : []string) -> bool {
        if len(args) != 1 do return false

        fmt.println("RotCom, the RotLang compiler v", ROT_VERSION)
        fmt.println("--- Rot Dictionary ---")
        fmt.println("> Help      | rot help")
        fmt.println("> Build     | rot build (path) (args)")
        fmt.println("> Translate | rot trans (path)")
        
        return true
    },

    "build" = proc(args : []string) -> bool {
        if len(args) < 2 do return false
    
        path := args[1]
        if !os.is_file(path) {
            fmt.println("Given file doesn't exist!")
            return false
        }
    
        if !strings.ends_with(path, ".rot") {
            fmt.println("Invalid file extension!")
            return false
        }
    
        // Translate file to .robj (c-file)
        new_path := translate_file(path, context.temp_allocator)
        if !os.is_file(new_path) {
            fmt.println(new_path)
            return false
        }

        // Compile with given compiler
        compiler := "g++"
        s_args := ""

        cmd := strings.concatenate({compiler, " ", new_path, " ", s_args}, context.temp_allocator)
        c_cmd := strings.clone_to_cstring(cmd, context.temp_allocator)

        libc.system(c_cmd)
    
        return true
    }
}

main :: proc() {

    // Get compiler arguments
    args := os.args[1:]
    switch len(args) {
    case 0:
        fmt.println("RotCom, the RotLang compiler.")
        fmt.println("Please provide arguments for the compiler, for help use 'rot help'.")

    case:
        mode := args[0]
        if mode in commands {
            if !commands[mode](args) {
                fmt.println("Incorrect parameters for given command, for help use 'rot help'.")
            }


        } else {
            fmt.println(mode, "is not a valid command. For help use 'rot help'.")
        
        }
    }

    delete(commands)
}