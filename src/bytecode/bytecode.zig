pub const std = @import("std");
pub const instructions = @import("instructions.zig");
pub const parse = @import("parse.zig").parse;
pub const opcodes = @import("opcodes.zig");
pub const constant = @import("../class_file/constant.zig");
pub const attributes = @import("../class_file/attributes.zig");
const bytes = @import("../bytes/bytes.zig");
const ALLOC = @import("../alloc.zig").ALLOC;

pub const Buffer = struct {
    max_stack: u16,
    max_locals: u16,
    data: std.ArrayList(instructions.Instruction),

    pub fn from_attr(attrs: attributes.Attributes, pool: *constant.Constants) !?Buffer {
        for (attrs.attributes.items) |attr| {
            const name = try pool.get_utf8(attr.attribute_name_index);

            if (name.len != 4) {
                continue;
            }

            const name_str: *[4]u8 = name[0..4];

            if (!std.mem.eql(u8, name_str, "Code")) {
                continue;
            }

            var reader = bytes.NewReader(attr.info.items);

            return try Buffer.parse(&reader);
        }

        return null;
    }

    pub fn parse(reader: *bytes.Reader) !Buffer {
        const max_stack = try reader.read_u16();
        const max_locals = try reader.read_u16();

        const code_length = try reader.read_u32();

        var code = try std.ArrayList(instructions.Instruction).initCapacity(ALLOC, code_length / 3 * 2);

        const code_end = reader.pos + @as(usize, code_length);

        while (reader.pos < code_end) {
            const inst = try @import("parse.zig").parse(reader);

            try code.append(inst);
        }

        return Buffer{ .max_stack = max_stack, .max_locals = max_locals, .data = code };
    }
};
