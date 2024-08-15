const std = @import("std");
const ALLOC = @import("alloc.zig").ALLOC;

pub const String = struct {
    data: std.ArrayList(u8),

    pub fn init(self: []u8) String {
        self.data = std.ArrayList(u8).initCapacity(ALLOC, self.len);
    }

    pub fn from_list(data: std.ArrayList(u8)) String {
        return String{ .data = data };
    }

    pub fn from_slice(data: []const u8) !String {
        var buffer = try std.ArrayList(u8).initCapacity(ALLOC, data.len);

        if (data[data.len - 1] == 0) {
            try buffer.appendSlice(data[0 .. data.len - 1]);
        } else {
            try buffer.appendSlice(data);
        }

        return String{
            .data = buffer,
        };
    }

    pub fn deinit(self: String) void {
        self.data.deinit(ALLOC);
    }

    pub fn len(self: String) usize {
        return self.data.items.len;
    }

    pub fn capacity(self: String) usize {
        return self.data.capacity;
    }

    pub fn push(self: *String, c: u8) !void {
        try self.data.append(c);
    }

    pub fn print(self: *const String) void {
        std.debug.print("{s}", .{self.data.items});
    }

    pub fn is(self: *const String, other: *const String) bool {
        return std.mem.eql(u8, self.data.items, other.data.items);
    }

    pub fn is_slice(self: *const String, other: []const u8) bool {
        return std.mem.eql(u8, self.data.allocatedSlice(), other);
    }

    pub fn clone(self: *const String) !String {
        var buffer = try std.ArrayList(u8).initCapacity(ALLOC, self.len());

        try buffer.appendSlice(self.data.allocatedSlice());

        return String{
            .data = buffer,
        };
    }
};

pub fn Flags(comptime T: type, comptime F: type) type {
    return struct {
        flags: F,

        pub fn from(val: F) @This() {
            return @This(){ .flags = val };
        }

        pub fn set(self: *@This(), flag: T) void {
            self.flags |= flag;
        }

        pub fn unset(self: *@This(), flag: T) void {
            self.flags &= ~flag;
        }

        pub fn isSet(self: *@This(), flag: T) bool {
            return (self.flags & flag) != 0;
        }

        pub fn print(self: *@This()) void {
            std.debug.print("{x}", .{self.flags});
        }
    };
}
