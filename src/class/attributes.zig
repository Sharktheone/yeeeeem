const std = @import("std");

const bytes = @import("../bytes/bytes.zig");

const ALLOC = @import("../alloc.zig").ALLOC;

pub const Attributes = struct {
    attributes: std.ArrayList(AttributeInfo),
};

pub const AttributeInfo = struct {
    attribute_name_index: u16,
    info: std.ArrayList(u8),
};

pub fn parse(reader: *bytes.Reader) !Attributes {
    var pool = std.ArrayList(AttributeInfo).init(ALLOC);

    const count = try reader.read_u16();

    try pool.resize(@as(usize, count));

    return .{
        .attributes = pool,
    };
}
