const stack = @import("stack.zig");
const class = @import("../class.zig");
const utils = @import("../utils.zig");
const instructions = @import("instructions.zig");
const bytecode = @import("../bytecode/bytecode.zig");
const variable = @import("variable.zig");
const locals = @import("locals.zig");
const std = @import("std");
const storage = @import("storage.zig");
const Method = @import("../class/method.zig").Method;
const env = @import("env.zig");

const ALLOC = @import("../alloc.zig").ALLOC;

const MAIN: []const u8 = "main:([Ljava/lang/String;)V";

pub const Error = error{ MainNotoFound, NoStorage, NoValue, NotEnoughArguments, TypeMismatch, ret, //TODO: this can never be an error, but zig wants it extra somehow
MissingClass, Utf8Error, NullPointerException, IncompatibleClassChangeError, NoSuchMethod, ClassNotFound } || std.mem.Allocator.Error;

pub const Vm = struct {
    storage: std.ArrayList(storage.Storage),
    classes: std.StringHashMap(*class.Class),

    current_class: ?*class.Class = null,

    pub fn init() !Vm {
        return Vm{
            .storage = try std.ArrayList(storage.Storage).initCapacity(ALLOC, 4),
            .classes = std.StringHashMap(*class.Class).init(ALLOC),
        };
    }

    pub fn init_env(self: *Vm) !void {
        try env.init(self);
    }

    pub fn entry(self: *Vm, c: *class.Class) !void {
        self.current_class = c;
        const method = c.get_method(try utils.String.from_slice(MAIN));

        if (method == null) {
            return Error.MainNotoFound;
        }

        const m = method.?;

        try self.invoke(m, &[0]variable.Variable{});
    }

    pub fn invoke(self: *Vm, m: *Method, args: []variable.Variable) Error!void {
        if (m.bytecode == null) {
            if (m.fn_ptr == null) {
                return Error.NoSuchMethod;
            }

            const ret = try m.fn_ptr.?(self, args);

            try self.push(ret);
        }

        const bc = &m.bytecode.?;
        try self.new_storage(bc.max_stack, bc.max_locals);

        for (args) |arg| {
            try self.push(arg);
        }

        try self.execute(bc);

        var s = try self.get_storage();

        const ret = try s.pop();

        self.pop_storage();

        try self.push(ret);
    }

    pub fn execute(self: *Vm, c: *bytecode.Buffer) Error!void {
        try instructions.execute(self, c);
    }

    pub fn ip(self: *Vm) !usize {
        const s = self.current_storage() orelse return error.NoStorage;

        return s.ip;
    }

    pub fn current_storage(self: *Vm) ?*storage.Storage {
        if (self.storage.items.len == 0) {
            return null;
        }

        return &self.storage.items[self.storage.items.len - 1];
    }

    pub fn get_storage(self: *Vm) !*storage.Storage {
        return self.current_storage() orelse return error.NoStorage;
    }

    pub fn new_storage(vm: *Vm, s_cap: u32, l_cap: u32) !void {
        const s = try storage.Storage.init(s_cap, l_cap);

        try vm.storage.append(s);
    }

    pub fn pop_storage(vm: *Vm) void {
        if (vm.storage.items.len == 0) {
            return;
        }

        _ = vm.storage.pop();
    }

    pub fn push(vm: *Vm, v: variable.Variable) Error!void {
        const s = vm.current_storage() orelse return error.NoStorage;

        try s.push(v);
    }

    pub fn dump(self: *Vm) void {
        var i: u32 = 0;
        for (self.storage.items) |*s| {
            std.debug.print("Storage: {} \n", .{i});
            s.dump();
            i += 1;
        }
    }

    pub fn get_class(self: *Vm, name: []const u8) ?*class.Class {
        return self.classes.get(name);
    }
};
