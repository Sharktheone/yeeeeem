const std = @import("std");
const vm = @import("../vm.zig");
const Variable = @import("../variable.zig").Variable;

pub fn iload(m: *vm.Vm, idx: u8) !void {
    var storage = try m.get_storage();

    const val = try storage.local(idx);

    try storage.push(try val.clone());
}
