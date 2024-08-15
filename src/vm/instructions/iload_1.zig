const std = @import("std");
const vm = @import("../vm.zig");
const Variable = @import("../variable.zig").Variable;

pub fn iload_1(m: *vm.Vm) !void {
    var storage = try m.get_storage();

    const val = storage.local_1();

    try storage.push(val);
}
