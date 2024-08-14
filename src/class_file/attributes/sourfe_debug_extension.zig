const std = @import("std");
const bytes = @import("bytes/bytes.zig");

pub const SourceDebugExtension = struct {
    data: std.ArrayList(u8),
};

pub fn parse(reader: *bytes.Reader, len: u32) !SourceDebugExtension {
    return SourceDebugExtension{
        .data = try reader.read(len),
    };
}
