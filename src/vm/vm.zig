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

    pub fn ip(self: *Vm) ?usize {
        return self.current_storage().?.ip;
    }

    pub fn current_storage(self: *Vm) ?*storage.Storage {
        if (self.storage.items.len == 0) {
            return null;
        }

        return &self.storage.items[self.storage.items.len - 1];
    }
};
