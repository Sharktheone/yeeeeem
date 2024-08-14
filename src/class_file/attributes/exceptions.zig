const std = @import("std");
const bytes = @import("bytes/bytes.zig");
const interface = @import("../interface.zig");
const ALLOC = @import("../../alloc.zig").ALLOC;

pub const Exceptions = struct { data: std.ArrayList(interface.ClassInfo) };

pub fn parse(reader: *bytes.Reader) !Exceptions {
    const count = reader.read_u16();

    var buffer = try std.ArrayList(interface.ClassInfo).initCapacity(ALLOC, count);

    for (count) |_| {
        const class_info = try interface.parseClassInfo(reader);
        try buffer.append(class_info);
    }
}
