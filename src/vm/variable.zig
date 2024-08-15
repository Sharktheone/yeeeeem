const utils = @import("../utils.zig");
const class = @import("../class.zig");

pub const Type = enum {
    void,
    int,
    long,
    float,
    double,
    string,
    objectref,
    class,
};

pub const Variable = union(Type) {
    void,
    int: i32,
    long: i64,
    float: f32,
    double: f64,
    string: utils.String,
    objectref: ObjectRef,
    class: *class.Class,

    pub fn clone(self: *Variable) !Variable {
        return switch (self.*) {
            .void => Variable.void,
            .int => |val| Variable{ .int = val },
            .long => |val| Variable{ .long = val },
            .float => |val| Variable{ .float = val },
            .double => |val| Variable{ .double = val },
            .string => |val| Variable{ .string = try val.clone() },
            .objectref => |val| Variable{ .objectref = val },
            .class => |val| Variable{ .class = val },
        };
    }

    pub fn dump(self: *Variable) void {
        const std = @import("std");

        switch (self.*) {
            .void => std.debug.print("void\n", .{}),
            .int => std.debug.print("int: {}\n", .{self.int}),
            .long => std.debug.print("long: {}\n", .{self.long}),
            .float => std.debug.print("float: {}\n", .{self.float}),
            .double => std.debug.print("double: {}\n", .{self.double}),
            .string => self.string.print(),
            .objectref => {
                std.debug.print("objectref: {}", .{self.objectref.class});
                if (self.objectref.field != null) {
                    self.objectref.field.?.print();
                }
                std.debug.print("\n", .{});
            },
            .class => std.debug.print("class: {}\n", .{self.class.name}),
        }
    }
};

pub const ObjectRef = struct {
    class: utils.String,
    field: ?utils.String,
};
