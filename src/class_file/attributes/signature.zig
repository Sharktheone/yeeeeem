const std = @import("std");
const bytes = @import("bytes/bytes.zig");

pub const Signature = struct {
    signature: u16,
};

pub fn parse(reader: *bytes.Reader) !Signature {
    return Signature{ .signature = try reader.read_u16() };
}
