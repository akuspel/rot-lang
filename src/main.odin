package rotcom

/* --- RotCom rot-lang Compiler ---
 * This is the main file for the Rot Language compiler
 * Where the main program and functions are defined.
 * 
 * Commands exist here too, but might be moved in the future.
 */

import "core:os"
import "core:fmt"
import "core:strings"
import "core:c/libc"

ROT_VERSION :: "0.02 - a"

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
        n_args := len(args)
        if n_args < 2 do return false
    
        path := args[1]
        if !os.is_file(path) {
            fmt.println("Given file doesn't exist!")
            return false
        }
    
        if strings.ends_with(path, ".rot") {

            keep := false // Keep files after building
    
            // Translate file to .robj (c-file)
            new_path := translate_file(path, context.temp_allocator)
            if !os.is_file(new_path) {
                fmt.println(new_path)
                return false
            }
            head_path := translate_file_to_header(
                path,
                context.temp_allocator
            )

            // Compile with given compiler
            compiler := "g++"
            s_args := ""

            if n_args > 2 {
                extra_args := args[2:]

                // Loop through extra arguments
                for arg in extra_args {

                    // Find compiler
                    FLAG_COMPILER :: "-comp="
                    FLAG_KEEP :: "-keep"
                    if strings.starts_with(arg, FLAG_COMPILER) {
                        compiler, _ = strings.replace(
                            arg, FLAG_COMPILER,
                            "", 1, context.temp_allocator
                        )
                        continue

                    } else if arg == FLAG_KEEP {
                        keep = true
                        continue
                    }

                    s_args, _ = strings.concatenate(
                        {s_args, " ", arg}, context.temp_allocator
                    )
                }
            }

            cmd := strings.concatenate({compiler, " ", new_path, s_args}, context.temp_allocator)
            if !strings.starts_with(cmd, "rot ") do cmd, _ = strings.replace_all(cmd, ".rot", ".c", context.temp_allocator)
            c_cmd := strings.clone_to_cstring(cmd, context.temp_allocator)
            libc.system(c_cmd)

            // After this has been done, delete the generated c file
            if !keep {
                delete_file(new_path)
                delete_file(head_path)
            }

        } else if strings.ends_with(path, ".rb") {
            
            // Run build file
            if !build_file(path) {
                return false
            }
            
        } else {
            fmt.println("Invalid file extension!")
            return false
        }
    
        return true
    },

    "trans" = proc(args : []string) -> bool {
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
        head_path := translate_file_to_header(
            path,
            context.temp_allocator
        )
    
        return true
    },

    "fanum_tax" = proc(args : []string) -> bool {

        taxpr := "fanum tax (int i; 0..=10) {"
        fmt.println(" rot :", taxpr)
        fmt.println("  c  :", fanum_tax(taxpr))
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