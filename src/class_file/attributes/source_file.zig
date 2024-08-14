const std = @import("std");
const bytes = @import("bytes/bytes.zig");

pub const SourceFile = struct {
    source_file_index: u16,
};

pub fn parse(reader: *bytes.Reader) !SourceFile {
    const source_file_index = try reader.read_u16();
    return SourceFile{ .source_file_index = source_file_index };
}
