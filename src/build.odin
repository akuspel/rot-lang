package rotcom

/* --- Rot Language Build System ---
 * In this file you can find behaviour and parsing for
 * Rot Language build files (.rb)
 */

// --- .rb example ---- //
// .com g++             // Define compiler
// .trans file1.rot     // Define rot files for translation
// .trans file2.rot     //
//                      //
// .build main.rot      // Define rot file for builing
// -------------------- //

import "core:os"
import "core:fmt"
import "core:strings"

// --- Procedures ---
build_file :: proc(path : string) -> bool {
    
    command_strs := [?]string {".com ", ".trans ", ".build "}
    temp := context.temp_allocator

    // Open file
    data, succ := os.read_entire_file_from_filename(path, temp)
    if !succ do return false

    // Get path prefix
    path_split := strings.split_multi(
        path, {"/", "//", "\\"},
        context.temp_allocator
    )
    
    file_name := path_split[len(path_split) - 1]
    path_prefix, _ := strings.replace(
        path, file_name, "", 1,
        context.temp_allocator
    )

    // Build options
    compiler := "g++"

    // Loop through each line and call
    text := transmute(string)data
    lines := strings.split(text, TOKEN_NEWLINE, temp)
    for l in lines {

        // Find correct command
        command : string
        for c in command_strs do if strings.starts_with(l, c) do command = c
        if  command == "" do continue

        // Switch command
        switch command {
        case command_strs[0]: // Set compiler
            compiler, _ = strings.substring_from(
                l, strings.rune_count(command)
            )
            compiler, _ = strings.replace_all(compiler, " ", "", temp)

        case command_strs[1]: // Translate file
            filepath, _ := strings.substring_from(
                l, strings.rune_count(command)
            )
            filepath = strings.trim_space(filepath)
            filepath = strings.concatenate(
                {path_prefix, filepath},
                context.temp_allocator
            )
            arg := fmt.tprintf("trans %s", filepath)

            // Feed args to command
            args, _ := strings.split(arg, " ", context.temp_allocator)
            if !commands["trans"](args) do return false
        
        case command_strs[2]: // Build file
            filepath, _ := strings.substring_from(
                l, strings.rune_count(command)
            )
            filepath = strings.trim_space(filepath)
            filepath = strings.concatenate(
                {path_prefix, filepath},
                context.temp_allocator
            )
            arg := fmt.tprintf("build %s -comp=%s", filepath, compiler)

            // Feed args to command
            args, _ := strings.split(arg, " ", context.temp_allocator)
            if !commands["build"](args) do return false
        }
    }

    return true
}