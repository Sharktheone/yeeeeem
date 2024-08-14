const std = @import("std");
const bytes = @import("bytes/bytes.zig");
const ALLOC = @import("../../alloc.zig").ALLOC;

pub const InnerClasses = struct {
    data: std.ArrayList(InnerClass),
};

pub const InnerClass = struct {
    info_index: u16,
    outer_index: u16,
    inner_name_index: u16,
    inner_access_flags: u16,

    fn parse(reader: *bytes.Reader) !InnerClass {
        return InnerClass{
            .info_index = try reader.read_u16(),
            .outer_index = try reader.read_u16(),
            .inner_name_index = try reader.read_u16(),
            .inner_access_flags = try reader.read_u16(),
        };
    }
};

pub fn parse(reader: *bytes.Reader) !InnerClasses {
    const count = try reader.read_u16();
    var buffer = std.ArrayList(InnerClass).initCapacity(ALLOC, count);

    for (count) |_| {
        try buffer.append(InnerClass.parse(reader));
    }
}
