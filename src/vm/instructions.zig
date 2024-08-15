const std = @import("std");

const vm = @import("vm.zig");
const bytecode = @import("../bytecode/bytecode.zig");
const OpCode = @import("../bytecode/opcodes.zig").OpCode;

const Error = vm.Error;

const i = @import("instructions/instruction_index.zig");

pub const ControlFlow = error{
    ret,
};

const ControlflowOrError = ControlFlow || Error;

pub fn execute(m: *vm.Vm, code: *bytecode.Buffer) Error!void {
    while (try m.ip() < code.data.items.len) {
        const inst = code.data.items[try m.ip()];

        execute_instruction(m, inst) catch |err| {
            if (err == ControlFlow.ret) {
                return;
            }

            return err;
        };
    }
}

pub fn execute_instruction(m: *vm.Vm, inst: bytecode.instructions.Instruction) ControlflowOrError!void {
    std.debug.print("Executing instruction {}\n", .{@as(OpCode, inst)});
    switch (inst) {
        .nop => {},
        .bipush => |val| try i.bipush(m, val),
        .istore_0 => try i.istore_0(m),
        .istore_1 => try i.istore_1(m),
        .istore_2 => try i.istore_2(m),
        .istore_3 => try i.istore_3(m),
        .istore => |val| try i.istore(m, val),
        .iload_0 => try i.iload_0(m),
        .iload_1 => try i.iload_1(m),
        .iload_2 => try i.iload_2(m),
        .iload_3 => try i.iload_3(m),
        .iload => |val| try i.iload(m, val),
        .imul => try i.imul(m),
        .iadd => try i.iadd(m),
        .isub => try i.isub(m),
        .idiv => try i.idiv(m),
        .irem => try i.irem(m),
        ._return => return ControlFlow.ret,
        .getstatic => |val| try i.getstatic(m, val),
        .invokevirtual => |val| try i.invokevirtual(m, val),
        .ldc => |val| try i.ldc(m, val),

        else => std.debug.panic("instruction {} is not implemented", .{@as(OpCode, inst)}),
    }

    (try m.get_storage()).ip += 1;
}
