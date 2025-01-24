package rotcom

/* --- Rot Language Translator ---
 * In this file you can find procedures, which are
 * Used for file translation and management
 */

import "core:os"
import "core:strings"
import win32 "core:sys/windows"
import "core:unicode/utf16"


// --- Procedures ---
translate_file :: proc(path : string, alloc := context.allocator) -> string {

    new_path, _ := strings.replace(path, ".rot", ".c", 1, alloc)

    // Open files (Use own temp allocator for this proc, since the data only needs to life so long)
    from, succ := os.read_entire_file_from_filename(path, context.temp_allocator)
    if !succ do return "Error, unable to open source file"
    data := transmute(string)from

    // Delete old file
    delete_file(new_path)

    // Create to file if not existing
    create_file(new_path)

    // Open to file
    to, err := os.open(new_path, os.O_WRONLY, 1)
    if err != nil do return "Error, unable to write to destination file"

    // Split data to lines, loop through them all
    lines := strings.split(data, TOKEN_NEWLINE)
    for l in lines {
        line := strings.concatenate(
            {parse_row(l, context.temp_allocator), "\n"},
            context.temp_allocator
        )

        // Write parsed lines to new file
        os.write_string(to, line)
    }

    os.close(to)
    return new_path
}

when ODIN_OS == .Windows {

    create_file :: proc(path : string) {

        if !os.is_file(path) {
            // Convert to WSTR
            str_data := make([]u16, 2*len(path))
            defer delete(str_data)
    
            utf16.encode_string(str_data, path)
            handle := win32.CreateFileW(
                raw_data(str_data),
                win32.GENERIC_ALL,
                win32.FILE_SHARE_WRITE,
                nil, win32.OPEN_ALWAYS,
                0, nil
            )
    
            if handle != nil do win32.CloseHandle(handle)
        }
    }

    delete_file :: proc(path : string) {
    
        // Delete file if available
        if os.is_file(path) {
            // Convert to WSTR
            str_data := make([]u16, 2*len(path))
            defer delete(str_data)
    
            utf16.encode_string(str_data, path)
            win32.DeleteFileW(raw_data(str_data))
        }
    }

    // TODO: Add support for other operating systems
}