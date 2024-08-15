const std = @import("std");
const vm = @import("../vm.zig");
const Variable = @import("../variable.zig").Variable;
const Class = @import("../../class.zig").Class;
const utils = @import("../../utils.zig");

pub fn ldc(m: *vm.Vm, idx: u16) !void {
    if (m.current_class == null) {
        return error.NoCurrentClass;
    }

    const class = m.current_class.?;

    const constant = try class.constant.get(idx);

    switch (constant) {
        .integer => |value| {
            try m.push(Variable{ .int = value.value });
        },

        .float => |value| {
            try m.push(Variable{ .float = value.value });
        },

        .string => |value| {
            const str_value = try class.constant.get_utf8(value.string_index);

            const str = try utils.String.from_slice(str_value);

            try m.push(Variable{ .string = str });
        },

        .class => |_| {
            @panic("Not implemented");
        },

        .long => |value| {
            try m.push(Variable{ .long = value.value });
        },

        .double => |value| {
            try m.push(Variable{ .double = value.value });
        },

        else => return error.InvalidConstantType,
    }
}
