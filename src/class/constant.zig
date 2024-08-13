const std = @import("std");
const bytes = @import("../bytes/bytes.zig");
const ALLOC = @import("../alloc.zig").ALLOC;

pub const Constants = struct {
    pool: std.ArrayList(Constant),
};

pub const Constant = enum {};

pub fn parse(reader: *bytes.Reader) !Constants {
    var pool = std.ArrayList(Constant).init(ALLOC);

    const count = try reader.read_u16();

    try pool.resize(@as(usize, count));

    //TODO: We need to read the constants here!

    return Constants{ .pool = pool };
}
