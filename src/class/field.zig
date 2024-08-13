const std = @import("std");
const attributes = @import("attributes.zig");

const bytes = @import("../bytes/bytes.zig");

const ALLOC = @import("../alloc.zig").ALLOC;

pub const Fields = struct {
    fields: std.ArrayList(FieldInfo),
};

pub const FieldInfo = struct {
    access_flags: FieldAccessFlags,
    name_index: u16,
    descriptor_index: u16,
    attributes: attributes.Attributes,
};

pub const FieldAccessFlags = enum {};

pub fn parse(reader: *bytes.Reader) !Fields {
    var pool = std.ArrayList(FieldInfo).init(ALLOC);

    const count = try reader.read_u16();

    try pool.resize(@as(usize, count));

    return .{
        .fields = pool,
    };
}
