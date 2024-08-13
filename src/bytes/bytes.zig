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
        if (self.pos >= self.buffer.len) {
            return Error.EOF;
        }

        const value = self.buffer[self.pos];
        self.pos += 1;
        return value;
    }

    pub fn read_u16(self: *Reader) Error!u16 {
        if (self.pos + 1 >= self.buffer.len) {
            return Error.EOF;
        }

        const a = self.buffer[self.pos];
        const b = self.buffer[self.pos + 1];

        self.pos += 2;

        return (@as(u16, a) << 8) | @as(u16, b);
    }

    pub fn read_u32(self: *Reader) Error!u32 {
        if (self.pos + 3 >= self.buffer.len) {
            return Error.EOF;
        }

        const a = self.buffer[self.pos];
        const b = self.buffer[self.pos + 1];
        const c = self.buffer[self.pos + 2];
        const d = self.buffer[self.pos + 3];

        self.pos += 4;

        return (@as(u32, a) << 24) | (@as(u32, b) << 16) | (@as(u32, c) << 8) | @as(u32, d);
    }

    pub fn read_u64(self: *Reader) Error!u64 {
        if (self.pos + 7 >= self.buffer.len) {
            return Error.EOF;
        }

        const a = self.buffer[self.pos];
        const b = self.buffer[self.pos + 1];
        const c = self.buffer[self.pos + 2];
        const d = self.buffer[self.pos + 3];
        const e = self.buffer[self.pos + 4];
        const f = self.buffer[self.pos + 5];
        const g = self.buffer[self.pos + 6];
        const h = self.buffer[self.pos + 7];

        self.pos += 8;

        return (@as(u64, a) << 56) | (@as(u64, b) << 48) | (@as(u64, c) << 40) | (@as(u64, d) << 32) | (@as(u64, e) << 24) | (@as(u64, f) << 16) | (@as(u64, g) << 8) | @as(u64, h);
    }

    pub fn read_n(self: *Reader, len: comptime_int) Error![len]u8 {
        if (self.pos + len >= self.buffer.len) {
            return Error.EOF;
        }

        const result: [len]u8 = self.buffer[self.pos .. self.pos + len];

        self.pos += len;

        return result;
    }
};
