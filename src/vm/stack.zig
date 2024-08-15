const utils = @import("../utils.zig");
const std = @import("std");
const variable = @import("variable.zig");
const ALLOC = @import("../alloc.zig").ALLOC;

const AllocError = std.mem.Allocator.Error;

pub const Stack = struct {
    frames: std.ArrayList(Frame),

    pub fn init(capacity: usize) AllocError!Stack {
        return Stack{
            .frames = try std.ArrayList(Frame).initCapacity(ALLOC, capacity),
        };
    }

    pub fn add_frame(self: *Stack, name: ?utils.String) AllocError!void {
        try self.frames.append(
            Frame{ .name = name, .variables = std.ArrayList(variable.Variable).init(ALLOC) },
        );
    }

    pub fn push(self: *Stack, v: variable.Variable) AllocError!void {
        if (self.frames.items.len == 0) {
            try self.add_frame(null);
        }

        var frame = &self.frames.items[self.frames.items.len - 1];
        try frame.push(v);
    }

    pub fn pop(self: *Stack) ?variable.Variable {
        if (self.frames.items.len == 0) {
            return null;
        }

        var frame = &self.frames.items[self.frames.items.len - 1];
        return frame.pop();
    }

    pub fn pop_frame(self: *Stack) ?Frame {
        if (self.frames.items.len == 0) {
            return null;
        }

        return self.frames.pop();
    }

    pub fn get_frame(self: *Stack, index: usize) ?*Frame {
        if (index >= self.frames.items.len) {
            return null;
        }

        return &self.frames.items[index];
    }

    pub fn load(self: *Stack, idx: usize) ?*variable.Variable {
        if (self.frames.items.len == 0) {
            return null;
        }

        var frame = &self.frames.items[self.frames.items.len - 1];

        return frame.load(idx);
    }

    pub fn dump(self: *Stack) void {
        for (self.frames.items) |*frame| {
            if (frame.name != null) {
                std.debug.print("Frame:", .{});
                frame.name.?.print();
            } else {
                std.debug.print("Frame: <unnamed>\n", .{});
            }

            for (frame.variables.items) |*v| {
                v.dump();
            }
        }
    }
};

pub const Frame = struct {
    name: ?utils.String,
    variables: std.ArrayList(variable.Variable),

    pub fn push(self: *Frame, v: variable.Variable) AllocError!void {
        try self.variables.append(v);
    }

    pub fn pop(self: *Frame) ?variable.Variable {
        if (self.variables.items.len == 0) {
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
