const std = @import("std");
const attributes = @import("attributes.zig");

const bytes = @import("../bytes/bytes.zig");

const ALLOC = @import("../alloc.zig").ALLOC;

pub const Methods = struct {
    methods: std.ArrayList(MethodInfo),
};

pub const MethodInfo = struct {
    access_flags: MethodAccessFlags,
    name_index: u16,
    descriptor_index: u16,
    attributes: attributes.Attributes,
};

pub const MethodAccessFlags = enum {
    ACC_PUBLIC,
    ACC_PRIVATE,
    ACC_PROTECTED,
    ACC_STATIC,
    ACC_FINAL,
    ACC_SYNCHRONIZED,
    ACC_BRIDGE,
    ACC_VARARGS,
    ACC_NATIVE,
    ACC_ABSTRACT,
    ACC_STRICT,
    ACC_SYNTHETIC,
};

pub fn parse(reader: *bytes.Reader) !Methods {
    var pool = std.ArrayList(MethodInfo).init(ALLOC);

    const count = try reader.read_u16();

    try pool.resize(@as(usize, count));

    return .{
        .methods = pool,
    };
}
