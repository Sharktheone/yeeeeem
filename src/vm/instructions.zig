const std = @import("std");

const vm = @import("vm.zig");
const bytecode = @import("../bytecode/bytecode.zig");
const OpCode = @import("../bytecode/opcodes.zig").OpCode;

pub const controlflow = error{
    ret,
};

pub fn execute(m: *vm.Vm, code: *bytecode.Buffer) !void {
    try m.new_storage(code.max_stack, code.max_locals);

    while (try m.ip() < code.data.items.len) {
        const inst = code.data.items[try m.ip()];

        execute_instruction(m, inst) catch |err| {
            if (err == controlflow.ret) {
                return;
            }
            return err;
        };
    }
}

pub fn execute_instruction(m: *vm.Vm, inst: bytecode.instructions.Instruction) !void {
    _ = m;

    switch (inst) {
        .nop => {},

        else => std.debug.panic("instruction {} is not implemented", .{@as(OpCode, inst)}),
    }
}
