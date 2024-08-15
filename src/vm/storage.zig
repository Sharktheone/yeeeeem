const std = @import("std");
const stack = @import("stack.zig");
const locals = @import("locals.zig");
const variable = @import("variable.zig");

pub const Storage = struct {
    stack: stack.Stack,
    locals: locals.Locals,
    ip: usize,

    pub fn init(s: u32, l: u32) !Storage {
        return Storage{
            .stack = try stack.Stack.init(s),
            .locals = try locals.Locals.init(l),
            .ip = 0,
        };
    }

    pub fn push(self: *Storage, value: variable.Variable) !void {
        try self.stack.push(value);
    }

    pub fn pop(self: *Storage) !variable.Variable {
        return self.stack.pop() orelse return error.NotEnoughArguments;
    }

    pub fn load(self: *Storage, index: u32) ?*variable.Variable {
        return self.stack.load(index);
    }

    pub fn local_0(self: *Storage) variable.Variable {
        return self.locals.zero;
    }

    pub fn local_1(self: *Storage) variable.Variable {
        return self.locals.one;
    }

    pub fn local_2(self: *Storage) variable.Variable {
        return self.locals.two;
    }

    pub fn local_3(self: *Storage) variable.Variable {
        return self.locals.three;
    }

    pub fn local(self: *Storage, index: u32) !*variable.Variable {
        return self.locals.load(index) orelse return error.NotEnoughArguments;
    }

    pub fn store(self: *Storage, index: u32, value: variable.Variable) !void {
        try self.locals.store(index, value);
    }

    pub fn store_0(self: *Storage, value: variable.Variable) void {
        self.locals.zero = value;
    }

    pub fn store_1(self: *Storage, value: variable.Variable) void {
        self.locals.one = value;
    }

    pub fn store_2(self: *Storage, value: variable.Variable) void {
        self.locals.two = value;
    }

    pub fn store_3(self: *Storage, value: variable.Variable) void {
        self.locals.three = value;
    }

    pub fn dump(self: *Storage) void {
        std.debug.print("Stack: ({})\n", .{self.stack.frames.items.len});
        self.stack.dump();
        std.debug.print("\nLocals: ({})", .{self.locals.rest.items.len + 4});
        self.locals.dump();
        std.debug.print("\n", .{});
    }
};
