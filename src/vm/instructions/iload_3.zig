const std = @import("std");
const vm = @import("../vm.zig");
const Variable = @import("../variable.zig").Variable;

pub fn iload_3(m: *vm.Vm) !void {
    var storage = try m.get_storage();

    const val = storage.local_3();

    try storage.push(val);
}
