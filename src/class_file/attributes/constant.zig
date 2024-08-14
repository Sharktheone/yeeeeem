const std = @import("std");
const bytes = @import("../bytes/bytes.zig");

pub const ConstantValue = struct {
    const_index: u16,
};

pub fn parse(reader: bytes.Reader) !ConstantValue {
    return ConstantValue{
        .const_index = try reader.read_u16(),
    };
}
