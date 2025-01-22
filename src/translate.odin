package rotcom

import "core:os"
import "core:strings"
import win32 "core:sys/windows"
import "core:unicode/utf16"


// --- Procedures ---
translate_file :: proc(path : string, alloc := context.allocator) -> string {

    new_path := strings.concatenate({strings.trim_right(path, ".rot"), ".c"}, alloc)

    // Open files (Use own temp allocator for this proc, since the data only needs to life so long)
    from, succ := os.read_entire_file_from_filename(path, context.temp_allocator)
    if !succ do return "Error, unable to open source file"
    data := transmute(string)from

    // Create to file if not existing
    if !os.is_file(new_path) {
        str_data := make([]u16, 2*len(new_path))
        defer delete(str_data)

        utf16.encode_string(str_data, new_path)
        handle := win32.CreateFileW(
            raw_data(str_data),
            win32.GENERIC_ALL,
            win32.FILE_SHARE_WRITE,
            nil, win32.OPEN_ALWAYS,
            0, nil
        )

        if handle != nil do win32.CloseHandle(handle)
    }

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