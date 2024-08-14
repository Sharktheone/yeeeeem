const std = @import("std");
const bytes = @import("bytes/bytes.zig");
const ALLOC = @import("../../alloc.zig").ALLOC;

pub const EnclosingMethod = struct {
    class_index: u16,
    method_index: u16,
};

pub fn parse(reader: *bytes.Reader) !EnclosingMethod {
    const class_index = try reader.read_u16();
    const method_index = try reader.read_u16();
    return EnclosingMethod{ .class_index = class_index, .method_index = method_index };
}
