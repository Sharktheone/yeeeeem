const utils = @import("../utils.zig");
const std = @import("std");
const variable = @import("../vm/variable.zig");

pub const Field = struct {
    value: variable.Variable,

    pub const _void = Field{
        .value = variable.Variable.void,
    };
};
