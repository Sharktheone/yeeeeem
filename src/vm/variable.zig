const utils = @import("../utils.zig");

pub const Variable = union(enum) {
    void,
    int: i32,
    long: i64,
    float: f32,
    double: f64,
    string: utils.String,

    pub fn clone(self: *Variable) !Variable {
        return switch (self.*) {
            .void => Variable.void,
            .int => |val| Variable{ .int = val },
            .long => |val| Variable{ .long = val },
            .float => |val| Variable{ .float = val },
            .double => |val| Variable{ .double = val },
            .string => |val| Variable{ .string = try val.clone() },
        };
    }
};
