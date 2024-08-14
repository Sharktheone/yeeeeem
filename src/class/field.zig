const utils = @import("../utils.zig");
const std = @import("std");

pub const Field = struct {
    full_name: std.ArrayList(u8),
};
