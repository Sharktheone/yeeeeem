const std = @import("std");

const variable = @import("variable.zig");

const ALLOC = @import("../alloc.zig").ALLOC;

pub const Locals = struct {
    zero: variable.Variable,
    one: variable.Variable,
    two: variable.Variable,
    three: variable.Variable,

    rest: std.ArrayList(variable.Variable),

    pub fn init(cap: u32) !Locals {
        return Locals{
            .zero = variable.Variable.void,
            .one = variable.Variable.void,
            .two = variable.Variable.void,
            .three = variable.Variable.void,
            .rest = try std.ArrayList(variable.Variable).initCapacity(ALLOC, cap),
        };
    }

    pub fn load(self: *Locals, idx: u32) ?*variable.Variable {
        const real_idx = idx - 4;

        if (real_idx >= self.rest.items.len) {
            return null;
        }

        return &self.rest.items[real_idx];
    }

    pub fn store(self: *Locals, idx: u32, value: variable.Variable) !void {
        const real_idx = idx - 4;

        if (real_idx >= self.rest.items.len) {
            try self.rest.append(value);
        } else {
            self.rest.items[real_idx] = value;
        }
    }
};
