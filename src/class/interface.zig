const std = @import("std");
const bytes = @import("../bytes/bytes.zig");

const ALLOC = @import("../alloc.zig").ALLOC;

pub const Interfaces = struct {
    interfaces: std.ArrayList(ClassInfo),
};

pub const ClassInfo = struct {
    tag: u8,
    name_index: u16,
};

pub fn parse(reader: *bytes.Reader) !Interfaces {
    var pool = std.ArrayList(ClassInfo).init(ALLOC);

    const count = try reader.read_u16();

    try pool.resize(@as(usize, count));

    return .{
        .interfaces = pool,
    };
}
