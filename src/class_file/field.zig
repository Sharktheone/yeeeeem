const std = @import("std");
const attributes = @import("attributes.zig");

const bytes = @import("../bytes/bytes.zig");

const ALLOC = @import("../alloc.zig").ALLOC;

pub const Fields = struct {
    fields: std.ArrayList(FieldInfo),
};

pub const FieldInfo = struct {
    access_flags: u16,
    name_index: u16,
    descriptor_index: u16,
    attributes: attributes.Attributes,

    fn parse(reader: *bytes.Reader) !FieldInfo {
        const access_flags = try reader.read_u16();
        const name_index = try reader.read_u16();
        const descriptor_index = try reader.read_u16();
        const attrs = try attributes.parse(reader);

        return .{
            .access_flags = access_flags,
            .name_index = name_index,
            .descriptor_index = descriptor_index,
            .attributes = attrs,
        };
    }
};

// pub const FieldAccessFlags = enum {};

pub fn parse(reader: *bytes.Reader) !Fields {
    const count = try reader.read_u16();
    var pool = try std.ArrayList(FieldInfo).initCapacity(ALLOC, count);

    for (0..count) |_| {
        const field = try FieldInfo.parse(reader);
        try pool.append(field);
    }

    return .{
        .fields = pool,
    };
}
