const std = @import("std");
const vm = @import("../vm.zig");
const Variable = @import("../variable.zig").Variable;

pub fn iload_0(m: *vm.Vm) !void {
    var storage = try m.get_storage();

    const val = storage.local_0();

    try storage.push(val);
}
