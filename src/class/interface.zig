const std = @import("std");
const bytes = @import("../bytes/bytes.zig");

const ALLOC = @import("../alloc.zig").ALLOC;

pub const Interfaces = struct {
    interfaces: std.ArrayList(ClassInfo),
};

pub const ClassInfo = struct {
    tag: u8,
    name_index: u16,

    fn parse(reader: *bytes.Reader) !ClassInfo {
        const tag = try reader.read_u8();
        const name_index = try reader.read_u16();

        return .{
            .tag = tag,
            .name_index = name_index,
        };
    }
};

pub fn parse(reader: *bytes.Reader) !Interfaces {
    const count = try reader.read_u16();
    var pool = try std.ArrayList(ClassInfo).initCapacity(ALLOC, count);

    for (0..count) |_| {
        const info = try ClassInfo.parse(reader);
        try pool.append(info);
    }

    return .{
        .interfaces = pool,
    };
}
