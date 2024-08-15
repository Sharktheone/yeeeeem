const utils = @import("../utils.zig");
const bytecode = @import("../bytecode/bytecode.zig");
const Error = @import("../vm/vm.zig").Error;
const vm = @import("../vm/vm.zig");
const variable = @import("../vm/variable.zig");

pub const Method = struct {
    access_flags: utils.Flags(MethodAccessFlags, u16),
    full_name: utils.String,
    bytecode: ?bytecode.Buffer,
    fn_ptr: ?*const fn (m: *vm.Vm, args: []variable.Variable) Error!variable.Variable,

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
