const std = @import("std");
const vm = @import("../vm.zig");
const Variable = @import("../variable.zig").Variable;

pub fn istore_1(m: *vm.Vm) !void {
    var storage = try m.get_storage();
    const value = try storage.pop();

    storage.store_1(value);
}
