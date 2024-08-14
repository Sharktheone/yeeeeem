const std = @import("std");
const attributes = @import("attributes.zig");

const bytes = @import("../bytes/bytes.zig");

const ALLOC = @import("../alloc.zig").ALLOC;

pub const Methods = struct {
    methods: std.ArrayList(MethodInfo),
};

pub const MethodInfo = struct {
    access_flags: u16,
    name_index: u16,
    descriptor_index: u16,
    attributes: attributes.Attributes,

    fn parse(reader: *bytes.Reader) !MethodInfo {
        const access_flags = try reader.read_u16();
        const name_index = try reader.read_u16();
        const descriptor_index = try reader.read_u16();
        const attrs = try attributes.parse(reader);

        return .{
            .access_flags = access_flags, //TODO: this is probably wrong, since access_flags is an bitfield
            .name_index = name_index,
            .descriptor_index = descriptor_index,
            .attributes = attrs,
        };
    }
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
    const count = try reader.read_u16();
    var pool = try std.ArrayList(MethodInfo).initCapacity(ALLOC, count);

    for (0..count) |_| {
        const method = try MethodInfo.parse(reader);
        try pool.append(method);
    }

    return .{
        .methods = pool,
    };
}
