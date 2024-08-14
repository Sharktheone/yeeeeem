const utils = @import("../utils.zig");
const bytecode = @import("../bytecode/bytecode.zig");

pub const Method = struct {
    access_flags: utils.Flags(MethodAccessFlags, u16),
    full_name: utils.String,
    bytecode: bytecode.Buffer,

    // attributes: MethodAttributes,
};

pub const MethodAccessFlags = enum {
    ACC_PUBLIC,
    ACC_PRIVATE,
    ACC_PROTECTED,
    ACC_STATIC,
    ACC_FINAL,
    ACC_SYNCHRONIZED,
    ACC_BRIDGE,
    ACC_VARARGS,
    ACC_NATIVE,
    ACC_ABSTRACT,
    ACC_STRICT,
    ACC_SYNTHETIC,
};

pub const MethodAttributes = struct {};
