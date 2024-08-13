const std = @import("std");
const class = @import("class.zig");
const bytes = @import("bytes/bytes.zig");

pub const Class = struct {
    minor_version: u16,
    major_version: u16,
};

pub fn parse(data: []u8) !Class {
    var reader = bytes.NewReader(data);

    const class_file = try class.parse(&reader);

    return Class{
        .minor_version = class_file.minor_version,
        .major_version = class_file.major_version,
    };
}
