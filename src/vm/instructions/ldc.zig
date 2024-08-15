const std = @import("std");
const vm = @import("../vm.zig");
const Variable = @import("../variable.zig").Variable;

pub fn ldc(m: *vm.Vm, idx: u16) !void {
    _ = m;
    _ = idx;
}
