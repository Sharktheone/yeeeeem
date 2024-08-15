const std = @import("std");
const bytes = @import("../bytes/bytes.zig");
const ALLOC = @import("../alloc.zig").ALLOC;
const utils = @import("../utils.zig");

const Error = error{
    Utf8Error,
};

pub const Constants = struct {
    pool: std.ArrayList(Constant),

    pub fn get_utf8(self: *Constants, index: u16) ![]u8 {
        const constant = try self.get(index);

        if (@as(ConstantTag, constant) != ConstantTag.utf8) {
            return Error.Utf8Error;
        }

        return constant.utf8.bytes.items;
    }

    pub fn get_class(self: *Constants, index: u16) ![]u8 {
        const constant = try self.get(index);

        if (@as(ConstantTag, constant) != ConstantTag.class) {
            return Error.Utf8Error;
        }

        return try self.get_utf8(constant.class.name_index);
    }

    pub fn get_full_name(self: *Constants, index: u16) !utils.String {
        const constant = try self.get(index);

        if (@as(ConstantTag, constant) != ConstantTag.name_and_type) {
            return Error.Utf8Error;
        }

        const name = try self.get_utf8(constant.name_and_type.name_index);
        const descriptor = try self.get_utf8(constant.name_and_type.descriptor_index);

        var str = try utils.String.from_slice(name);

        try str.push(':');
        try str.data.appendSlice(descriptor);

        return str;
    }

    pub fn get(self: *Constants, index: u16) Error!Constant {
        if (self.pool.items.len <= index - 1) {
            return Error.Utf8Error;
        }

        return self.pool.items[index - 1];
    }
};

pub const ConstantTag = enum(u8) {
    class = 7,
    field_ref = 9,
    method_ref = 10,
    interface_method_ref = 11,
    string = 8,
    integer = 3,
    float = 4,
    long = 5,
    double = 6,
    name_and_type = 12,
    utf8 = 1,
    method_handle = 15,
    method_type = 16,
    invoke_dynamic = 18,
};

pub const Constant = union(ConstantTag) {
    class: struct {
        name_index: u16,
    },
    field_ref: struct {
        class_index: u16,
        name_and_type_index: u16,
    },
    method_ref: struct {
        class_index: u16,
        name_and_type_index: u16,
    },
    interface_method_ref: struct {
        class_index: u16,
        name_and_type_index: u16,
    },
    string: struct {
        string_index: u16,
    },
    integer: struct {
        value: i32,
    },
    float: struct {
        value: f32,
    },
    long: struct {
        value: i64,
    },
    double: struct {
        value: f64,
    },
    name_and_type: struct {
        name_index: u16,
        descriptor_index: u16,
    },
    utf8: struct {
        bytes: std.ArrayList(u8),
    },
    method_handle: struct {
        reference_kind: ReferenceKind,
        reference_index: u16,
    },
    method_type: struct {
        descriptor_index: u16,
    },
    invoke_dynamic: struct {
        bootstrap_method_attr_index: u16,
        name_and_type_index: u16,
    },

    fn parse(reader: *bytes.Reader) !Constant {
        const tag_val = try reader.read_u8();

        const tag: ConstantTag = @enumFromInt(tag_val);

        return switch (tag) {
            .class => Constant{ .class = .{ .name_index = try reader.read_u16() } },
            .field_ref => Constant{ .field_ref = .{
                .class_index = try reader.read_u16(),
                .name_and_type_index = try reader.read_u16(),
            } },
            .method_ref => Constant{ .method_ref = .{
                .class_index = try reader.read_u16(),
                .name_and_type_index = try reader.read_u16(),
            } },
            .interface_method_ref => Constant{ .interface_method_ref = .{
                .class_index = try reader.read_u16(),
                .name_and_type_index = try reader.read_u16(),
            } },
            .string => Constant{ .string = .{ .string_index = try reader.read_u16() } },
            .integer => Constant{ .integer = .{ .value = try reader.read_i32() } },
            .float => Constant{ .float = .{ .value = try reader.read_f32() } },
            .long => Constant{ .long = .{ .value = try reader.read_i64() } },
            .double => Constant{ .double = .{ .value = try reader.read_f64() } },
            .name_and_type => Constant{ .name_and_type = .{
                .name_index = try reader.read_u16(),
                .descriptor_index = try reader.read_u16(),
            } },
            .utf8 => Constant{ .utf8 = .{ .bytes = try read_utf8(reader) } },
            .method_handle => Constant{ .method_handle = .{
                .reference_kind = @enumFromInt(try reader.read_u8()),
                .reference_index = try reader.read_u16(),
            } },
            .method_type => Constant{ .method_type = .{ .descriptor_index = try reader.read_u16() } },
            .invoke_dynamic => Constant{ .invoke_dynamic = .{
                .bootstrap_method_attr_index = try reader.read_u16(),
                .name_and_type_index = try reader.read_u16(),
            } },
        };
    }
};

fn read_utf8(reader: *bytes.Reader) !std.ArrayList(u8) {
    const length = try reader.read_u16();

    return reader.read(length);
}

pub const ReferenceKind = enum(u8) {
    GetField = 1,
    GetStatic = 2,
    PutField = 3,
    PutStatic = 4,
    InvokeVirtual = 5,
    InvokeStatic = 6,
    InvokeSpecial = 7,
    NewInvokeSpecial = 8,
    InvokeInterface = 9,
};

pub fn parse(reader: *bytes.Reader) !Constants {
    var pool = std.ArrayList(Constant).init(ALLOC);

    const count = try reader.read_u16();

    for (0..count - 1) |i| {
        std.debug.print("#{}: ", .{i});

        const constant = try Constant.parse(reader);

        try pool.append(constant);
    }

    return Constants{ .pool = pool };
}
