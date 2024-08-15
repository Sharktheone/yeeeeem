const stack = @import("stack.zig");
const class = @import("../class.zig");
const utils = @import("../utils.zig");
const instructions = @import("instructions.zig");
const bytecode = @import("../bytecode/bytecode.zig");
const variable = @import("variable.zig");
const locals = @import("locals.zig");
const std = @import("std");
const storage = @import("storage.zig");

const ALLOC = @import("../alloc.zig").ALLOC;

const MAIN: []const u8 = "main:([Ljava/lang/String;)V";

const Error = error{
    MainNotoFound,
};

pub const Vm = struct {
    storage: std.ArrayList(storage.Storage),

    pub fn init() !Vm {
        return Vm{
            .storage = try std.ArrayList(storage.Storage).initCapacity(ALLOC, 4),
        };
    }

    pub fn init_env(self: *Vm) !void {
        _ = self;
        //TODO: implement
    }

    pub fn entry(self: *Vm, c: *class.Class) !void {
        const method = c.search_method(try utils.String.from_slice(MAIN));

        if (method == null) {
            return Error.MainNotoFound;
        }

        var m = method.?;

        try self.execute(&m.bytecode);
    }

    pub fn execute(self: *Vm, c: *bytecode.Buffer) !void {
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

        _ = vm.storage.items.pop();
    }

    pub fn push(vm: *Vm, v: variable.Variable) !void {
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
};
