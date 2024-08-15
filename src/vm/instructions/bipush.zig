const std = @import("std");
const vm = @import("../vm.zig");
const Variable = @import("../variable.zig").Variable;

pub fn bipush(m: *vm.Vm, val: i8) !void {
    const v = Variable{
        .int = val,
    };

    try m.push(v);
}
