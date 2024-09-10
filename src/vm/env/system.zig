const vm = @import("../vm.zig");
const Class = @import("../../class.zig").Class;
const constants = @import("../../class_file/constant.zig");
const ALLOC = @import("../../alloc.zig").ALLOC;
const std = @import("std");
const method = @import("../../class/method.zig");
const field = @import("../../class/field.zig");
const utils = @import("../../utils.zig");
const variable = @import("../variable.zig");

const print_stream = @import("system/printstream.zig");

pub fn init(m: *vm.Vm) !void {
    const system = try ALLOC.create(Class);

    system.*.name = try utils.String.from_slice("java/lang/System");
    system.*.minor_version = 0;
    system.*.major_version = 0;
    system.*.constant = constants.Constants.init();
    system.*.fields = std.StringHashMap(field.Field).init(ALLOC);
    system.*.methods = std.ArrayList(method.Method).init(ALLOC);

    const out = try print_stream.init();

    try system.*.fields.put("out:Ljava/io/PrintStream;", field.Field{ .value = variable.Variable{
        .class = out,
    } });

    _ = try m.classes.fetchPut(system.*.name.data.items, system);
}
