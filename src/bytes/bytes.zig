const std = @import("std");

const ALLOC = @import("../alloc.zig").ALLOC;

pub const Error = error{
    EOF,
};

pub fn NewReader(buffer: []u8) Reader {
    return Reader{ .buffer = buffer, .pos = 0 };
}

pub const Reader = struct {
    buffer: []u8,
    pos: usize,

    pub fn read_u8(self: *Reader) Error!u8 {
        return std.mem.readInt(u8, try self.read_n(1), std.builtin.Endian.big);
    }

    pub fn read_u16(self: *Reader) Error!u16 {
        return std.mem.readInt(u16, try self.read_n(2), std.builtin.Endian.big);
    }

    pub fn read_u32(self: *Reader) Error!u32 {
        return std.mem.readInt(u32, try self.read_n(4), std.builtin.Endian.big);
    }

    pub fn read_u64(self: *Reader) Error!u64 {
        return std.mem.readInt(u64, try self.read_n(8), std.builtin.Endian.big);
    }

    pub fn read_i32(self: *Reader) Error!i32 {
        return std.mem.readInt(i32, try self.read_n(4), std.builtin.Endian.big);
    }

    pub fn read_i64(self: *Reader) Error!i64 {
        return std.mem.readInt(i64, try self.read_n(8), std.builtin.Endian.big);
    }

    pub fn read_f32(self: *Reader) Error!f32 {
        const value = try self.read_u32();

        return @bitCast(value);
    }

    pub fn read_f64(self: *Reader) Error!f64 {
        const value = try self.read_u64();

        return @bitCast(value);
    }

    pub fn read_n(self: *Reader, len: comptime_int) Error!*[len]u8 {
        if (self.pos + len >= self.buffer.len) {
            return Error.EOF;
        }

        const result = self.buffer[self.pos..][0..len];

        self.pos += len;

        return result;
    }

    pub fn read(self: *Reader, len: usize) !std.ArrayList(u8) {
        if (self.pos + len > self.buffer.len) {
            return Error.EOF;
        }

        const result = try std.ArrayList(u8).initCapacity(ALLOC, len);
        // try result.insertSlice(0, self.buffer[self.pos .. self.pos + len]);
        //TODO: somehow move the slice into the arraylist

        self.pos += len;

        return result;
    }
};
