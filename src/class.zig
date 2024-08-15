const class_file = @import("class_file.zig");
const std = @import("std");
const bytes = @import("bytes/bytes.zig");
const bytecode = @import("bytecode/bytecode.zig");
const constant = @import("class_file/constant.zig");
const Field = @import("class/field.zig").Field;
const Method = @import("class/method.zig").Method;
const ALLOC = @import("alloc.zig").ALLOC;
const utils = @import("utils.zig");
const method = @import("class/method.zig");

pub const Class = struct {
    minor_version: u16,
    major_version: u16,
    constant: constant.Constants,
    fields: std.StringHashMap(Field),
    methods: std.ArrayList(Method),
    name: utils.String,

    pub fn get_method(self: *Class, full_name: utils.String) ?*Method {
        for (self.methods.items) |*m| {
            if (m.full_name.is(&full_name)) {
                return m;
            }
        }

        return null;
    }

    pub fn get_field(self: *Class, full_name: []const u8) ?Field {
        return self.fields.get(full_name);
    }
};

pub fn parse(data: []u8) !Class {
    var reader = bytes.NewReader(data);

    var cf = try class_file.parse(&reader);

    var fields = std.StringHashMap(Field).init(ALLOC);
    try fields.ensureTotalCapacity(@intCast(cf.fields.fields.items.len));

    for (cf.fields.fields.items) |f| {
        const name = try cf.constant.get_utf8(f.name_index);
        const descriptor = try cf.constant.get_utf8(f.descriptor_index);

        const full_length = name.len + descriptor.len + 1;

        var full_name = try std.ArrayList(u8).initCapacity(ALLOC, full_length);
        try full_name.appendSlice(name);
        try full_name.append(':');
        try full_name.appendSlice(descriptor);

        _ = try fields.fetchPut(full_name.items, Field._void);
    }

    var methods = try std.ArrayList(Method).initCapacity(ALLOC, cf.methods.methods.items.len);

    for (cf.methods.methods.items) |m| {
        const name = try cf.constant.get_utf8(m.name_index);
        const descriptor = try cf.constant.get_utf8(m.descriptor_index);

        const full_length = name.len + descriptor.len + 1;

        var full_name = try std.ArrayList(u8).initCapacity(ALLOC, full_length);
        try full_name.appendSlice(name);
        try full_name.append(':');
        try full_name.appendSlice(descriptor);

        try methods.append(Method{ .access_flags = utils.Flags(method.MethodAccessFlags, u16).from(m.access_flags), .full_name = utils.String.from_list(full_name), .bytecode = try bytecode.Buffer.from_attr(m.attributes, &cf.constant) orelse {
            continue;
        } });
    }

    const name_slice = try cf.constant.get_class(cf.this_class);

    const name = try utils.String.from_slice(name_slice);

    return Class{
        .minor_version = cf.minor_version,
        .major_version = cf.major_version,
        .constant = cf.constant,
        .fields = fields,
        .methods = methods,
        .name = name,
    };
}
