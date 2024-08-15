const std = @import("std");

const vm = @import("vm.zig");
const bytecode = @import("../bytecode/bytecode.zig");

pub const controlflow = error{
    ret,
};

pub fn execute(m: *vm.Vm, code: *bytecode.Buffer) !void {
    _ = m;
    _ = code;

    //TODO: implement

}
