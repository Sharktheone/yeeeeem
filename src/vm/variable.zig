const utils = @import("../utils.zig");

pub const Variable = union(enum) {
    void,
    Int: i32,
    Long: i64,
    Float: f32,
    Double: f64,
    String: utils.String,
};
