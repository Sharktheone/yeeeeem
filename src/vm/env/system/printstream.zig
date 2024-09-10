const class = @import("../../../class.zig");
const constants = @import("../../../class_file/constant.zig");
const ALLOC = @import("../../../alloc.zig").ALLOC;
const utils = @import("../../../utils.zig");
const vm = @import("../../../vm/vm.zig");
const field = @import("../../../class/field.zig");
const method = @import("../../../class/method.zig");
const variable = @import("../../../vm/variable.zig");

const std = @import("std");

const Error = vm.Error;

pub fn init() !*class.Class {
    const printstream = try ALLOC.create(class.Class);

    printstream.*.name = try utils.String.from_slice("java/io/PrintStream");
    printstream.*.minor_version = 0;
    printstream.*.major_version = 0;
    printstream.*.constant = constants.Constants.init();
    printstream.*.fields = std.StringHashMap(field.Field).init(ALLOC);
    printstream.*.methods = std.ArrayList(method.Method).init(ALLOC);

    try printstream.*.fields.ensureTotalCapacity(10);

    const println_str = method.Method{
        .access_flags = utils.Flags(method.MethodAccessFlags, u16).from(0),
        .bytecode = null,
        .fn_ptr = println_fn,
        .full_name = try utils.String.from_slice("println:(Ljava/lang/String;)V"),
    };

    try printstream.*.methods.append(println_str);

    const println_int = method.Method{
        .access_flags = utils.Flags(method.MethodAccessFlags, u16).from(0),
        .bytecode = null,
        .fn_ptr = println_fn,
        .full_name = try utils.String.from_slice("println:(I)V"),
    };

    try printstream.*.methods.append(println_int);

    const println_bool = method.Method{
        .access_flags = utils.Flags(method.MethodAccessFlags, u16).from(0),
        .bytecode = null,
        .fn_ptr = println_fn,
        .full_name = try utils.String.from_slice("println:(Z)V"),
    };

    try printstream.*.methods.append(println_bool);

    const println_char = method.Method{
        .access_flags = utils.Flags(method.MethodAccessFlags, u16).from(0),
        .bytecode = null,
        .fn_ptr = println_fn,
        .full_name = try utils.String.from_slice("println:(C)V"),
    };

    try printstream.*.methods.append(println_char);

    const println_float = method.Method{
        .access_flags = utils.Flags(method.MethodAccessFlags, u16).from(0),
        .bytecode = null,
        .fn_ptr = println_fn,
        .full_name = try utils.String.from_slice("println:(F)V"),
    };

    try printstream.*.methods.append(println_float);

    const println_double = method.Method{
        .access_flags = utils.Flags(method.MethodAccessFlags, u16).from(0),
        .bytecode = null,
        .fn_ptr = println_fn,
        .full_name = try utils.String.from_slice("println:(D)V"),
    };

    try printstream.*.methods.append(println_double);

    const println_long = method.Method{
        .access_flags = utils.Flags(method.MethodAccessFlags, u16).from(0),
        .bytecode = null,
        .fn_ptr = println_fn,
        .full_name = try utils.String.from_slice("println:(J)V"),
    };

    try printstream.*.methods.append(println_long);

    const println = method.Method{
        .access_flags = utils.Flags(method.MethodAccessFlags, u16).from(0),
        .bytecode = null,
        .fn_ptr = println_fn,
        .full_name = try utils.String.from_slice("println:()V"),
    };

    try printstream.*.methods.append(println);

    return printstream;
}

fn println_fn(m: *vm.Vm, args: []variable.Variable) Error!variable.Variable {
    _ = m;

    if (args.len == 0) {
        return variable.Variable.void;
    }

    const arg = args[0];

    arg.print();
    std.debug.print("\n", .{});

    return variable.Variable.void;
}
