const std = @import("std");
const vm = @import("../vm.zig");
const Variable = @import("../variable.zig").Variable;

pub fn istore(m: *vm.Vm, idx: u8) !void {
    var storage = try m.get_storage();
    const value = try storage.pop();

    try storage.store(idx, value);
}
