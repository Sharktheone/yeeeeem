const std = @import("std");
const bytes = @import("bytes/bytes.zig");
const constants = @import("class/constant.zig");
const interface = @import("class/interface.zig");
const field = @import("class/field.zig");
const method = @import("class/method.zig");
const attribute = @import("class/attributes.zig");

pub const ClassFile = struct {
    minor_version: u16,
    major_version: u16,
    constant: constants.Constants,
    access_flags: u16,
    this_class: u16,
    super_class: u16,
    interfaces: interface.Interfaces,
    fields: field.Fields,
    methods: method.Methods,
    attributes: attribute.Attributes,
};

pub const Error = error{
    NotAClassFile,
};

pub fn parse(data: *bytes.Reader) !ClassFile {
    const magic = try data.read_u32(); // magic tag

    if (magic != 0xCAFEBABE) {
        return Error.NotAClassFile;
    }

    const minor_version = try data.read_u16();
    const major_version = try data.read_u16();

    std.debug.print("minor_version: {}\n", .{minor_version});
    std.debug.print("major_version: {}\n", .{major_version});

    const constant = try constants.parse(data);
    const access_flags = try data.read_u16();
    const this_class = try data.read_u16();
    const super_class = try data.read_u16();
    const interfaces = try interface.parse(data);
    const fields = try field.parse(data);
    const methods = try method.parse(data);
    const attributes = try attribute.parse(data);

    return ClassFile{
        .minor_version = minor_version,
        .major_version = major_version,
        .constant = constant,
        .access_flags = access_flags,
        .this_class = this_class,
        .super_class = super_class,
        .interfaces = interfaces,
        .fields = fields,
        .methods = methods,
        .attributes = attributes,
    };
}
