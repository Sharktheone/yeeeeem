const std = @import("std");

const root = @import("root.zig");

const ALLOC = @import("alloc.zig").ALLOC;

pub fn main() !void {
    const file_name = "Main.class";

    var path_buffer: [std.fs.MAX_PATH_BYTES]u8 = undefined;
    const path = try std.fs.realpath(file_name, &path_buffer);

    const file = try std.fs.openFileAbsolute(path, .{});
    defer file.close();

    const stat = try file.stat();

    try file.seekTo(0);
    const bytes_read = try file.readToEndAlloc(ALLOC, stat.size);
    defer ALLOC.free(bytes_read);

    const class_file = try root.parse(bytes_read);

    _ = class_file;

    std.debug.print("Read {d} bytes\n", .{bytes_read});
}
