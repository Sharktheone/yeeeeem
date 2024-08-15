const std = @import("std");
const vm = @import("../vm.zig");
const Variable = @import("../variable.zig").Variable;

pub fn istore_0(m: *vm.Vm) !void {
    var storage = try m.get_storage();
    const value = try storage.pop();

    storage.store_0(value);
}