const std = @import("std");
const vm = @import("../vm.zig");
const Variable = @import("../variable.zig").Variable;

pub fn iload_2(m: *vm.Vm) !void {
    var storage = try m.get_storage();

    const val = storage.local_2();

    try storage.push(val);
}
