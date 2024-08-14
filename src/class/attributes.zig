const std = @import("std");

const bytes = @import("../bytes/bytes.zig");

const ALLOC = @import("../alloc.zig").ALLOC;

pub const Attributes = struct {
    attributes: std.ArrayList(AttributeInfo),
};

pub const AttributeInfo = struct {
    attribute_name_index: u16,
    info: std.ArrayList(u8),

    pub fn parse(reader: *bytes.Reader) !AttributeInfo {
        const name_index = try reader.read_u16();
        const count = try reader.read_u32();

        const info = try reader.read(count);

        return .{
            .attribute_name_index = name_index,
            .info = info,
        };
    }
};

pub fn parse(reader: *bytes.Reader) !Attributes {
    const count = try reader.read_u16();

    var attributes = try std.ArrayList(AttributeInfo).initCapacity(ALLOC, count);

    for (0..count) |_| {
        const info = try AttributeInfo.parse(reader);
        try attributes.append(info);
    }

    return .{ .attributes = attributes };
}
