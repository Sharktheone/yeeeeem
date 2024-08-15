const std = @import("std");
const virtual_machine = @import("vm/vm.zig");
const class = @import("class.zig");

const ALLOC = @import("alloc.zig").ALLOC;

pub fn main() !void {
    const args = try std.process.argsAlloc(ALLOC);

    if (args.len != 2) {
        std.debug.print("Usage: {s} <class file>\n", .{args[0]});
        return;
    }

    const file_name = args[1];

    var path_buffer: [std.fs.MAX_PATH_BYTES]u8 = undefined;
    const path = try std.fs.realpath(file_name, &path_buffer);

    const file = try std.fs.openFileAbsolute(path, .{});
    defer file.close();

    const stat = try file.stat();

    try file.seekTo(0);
    const bytes_read = try file.readToEndAlloc(ALLOC, stat.size);

    defer ALLOC.free(bytes_read);

    var cf = try class.parse(bytes_read);

    var vm = try virtual_machine.Vm.init();

    try vm.init_env();

    try vm.entry(&cf);

    vm.dump();
}
