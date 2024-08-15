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

        try buffer.appendSlice(data);

        return String{
            .data = buffer,
        };
    }

    pub fn deinit(self: String) void {
        self.data.deinit(ALLOC);
    }

    pub fn len(self: String) usize {
        return self.data.len;
    }

    pub fn capacity(self: String) usize {
        return self.data.capacity;
    }

    pub fn push(self: *String, c: u8) void {
        self.data.items.append(ALLOC, c);
    }

    pub fn print(self: *String) void {
        std.debug.print("{s}", .{self.data.allocatedSlice()});
    }

    pub fn is(self: *const String, other: *const String) bool {
        return std.mem.eql(u8, self.data.allocatedSlice(), other.data.allocatedSlice());
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
