const utils = @import("../utils.zig");
const std = @import("std");
const variable = @import("variable.zig");
const ALLOC = @import("../alloc.zig").ALLOC;

pub const Stack = struct {
    frames: std.ArrayList(Frame),

    pub fn init(capacity: usize) !Stack {
        return Stack{
            .frames = try std.ArrayList(Frame).initCapacity(ALLOC, capacity),
        };
    }

    pub fn add_frame(self: *Stack, name: ?utils.String) !void {
        try self.frames.append(
            Frame{ .name = name, .variables = std.ArrayList.init(ALLOC) },
        );
    }

    pub fn push(self: *Stack, v: variable.Variable) !void {
        if (self.frames.len == 0) {
            self.add_frame(null);
        }

        const frame = self.frames.items[self.frames.len - 1];
        try frame.variables.append(v);
    }

    pub fn pop(self: *Stack) ?variable.Variable {
        if (self.frames.len == 0) {
            return null;
        }

        const frame = self.frames.items[self.frames.len - 1];
        return frame.pop();
    }

    pub fn pop_frame(self: *Stack) ?Frame {
        if (self.frames.len == 0) {
            return null;
        }

        return self.frames.pop();
    }

    pub fn get_frame(self: *Stack, index: usize) ?*Frame {
        if (index >= self.frames.len) {
            return null;
        }

        return &self.frames.items[index];
    }

    pub fn load(self: *Stack, idx: usize) ?*variable.Variable {
        if (self.frames.len == 0) {
            return null;
        }

        const frame = self.frames.items[self.frames.len - 1];

        return frame.load(idx);
    }
};

pub const Frame = struct {
    name: ?utils.String,
    variables: std.ArrayList(variable.Variable),

    pub fn push(self: *Frame, v: variable.Variable) !void {
        try self.variables.append(v);
    }

    pub fn pop(self: *Frame) ?variable.Variable {
        if (self.variables.len == 0) {
            return null;
        }

        return self.variables.pop();
    }

    pub fn load(self: *Frame, idx: usize) ?*variable.Variable {
        if (idx >= self.variables.len) {
            return null;
        }

        return &self.variables.items[idx];
    }
};
