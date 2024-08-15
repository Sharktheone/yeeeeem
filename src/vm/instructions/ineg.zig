const std = @import("std");
const vm = @import("../vm.zig");
const Variable = @import("../variable.zig").Variable;

pub fn ineg(m: *vm.Vm) !void {
    var s = try m.get_storage();

    const a = switch (try s.pop()) {
        .int => |i| i,
        else => return error.TypeMismatch,
    };

    try s.push(Variable{ .int = -a });
}