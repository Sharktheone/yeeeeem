const class_file = @import("class_file.zig");
const std = @import("std");
const bytes = @import("bytes/bytes.zig");
const bytecode = @import("bytecode/bytecode.zig");

pub const Class = struct {
    minor_version: u16,
    major_version: u16,
};

pub fn parse(data: []u8) !Class {
    var reader = bytes.NewReader(data);

    const cf = try class_file.parse(&reader);

    _ = try bytecode.parse(&reader);

    return Class{
        .minor_version = cf.minor_version,
        .major_version = cf.major_version,
    };
}
