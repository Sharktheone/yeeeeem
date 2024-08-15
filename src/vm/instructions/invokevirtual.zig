const std = @import("std");
const vm = @import("../vm.zig");
const Variable = @import("../variable.zig").Variable;
const variable = @import("../variable.zig");
const ALLOC = @import("../../alloc.zig").ALLOC;
const constant = @import("../../class_file/constant.zig");
const methods = @import("../../class/method.zig");
const utils = @import("../../utils.zig");

pub fn invokevirtual(m: *vm.Vm, mref_idx: u16) !void {
    var args = std.ArrayList(Variable).init(ALLOC);
    var objectref: variable.ObjectRef = undefined;

    const s = try m.get_storage();

    s.dump();

    while (true) {
        const arg = try s.pop();

        if (@as(variable.Type, arg) == variable.Type.objectref) {
            objectref = arg.objectref;
            break;
        }

        try args.append(arg);
    }

    var class = m.get_class(objectref.class.data.items) orelse return error.NullPointerException;

    if (m.current_class == null) {
        return error.NullPointerException;
    }

    const const_items = &m.current_class.?.constant;
    const mref = try const_items.get(mref_idx);

    if (@as(constant.ConstantTag, mref) != constant.ConstantTag.method_ref) {
        return error.IncompatibleClassChangeError;
    }

    const method = mref.method_ref;

    const class_name_const = try const_items.get(method.class_index);

    if (@as(constant.ConstantTag, class_name_const) != constant.ConstantTag.class) {
        return error.IncompatibleClassChangeError;
    }

    const class_name_idx = class_name_const.class.name_index;

    const class_name = try const_items.get_utf8(class_name_idx);

    if (!class.name.is_slice(class_name)) {
        return error.IncompatibleClassChangeError;
    }

    const full_name = try const_items.get_full_name(method.name_and_type_index);

    var target: *methods.Method = undefined;

    if (objectref.field != null) {
        const f = class.get_field(objectref.field.?.data.items) orelse return error.NullPointerException;

        if (@as(variable.Type, f.value) != variable.Type.class) {
            return error.IncompatibleClassChangeError;
        }

        const field = f.value.class;

        target = field.get_method(full_name) orelse return error.NoSuchMethodError;
    } else {
        target = class.get_method(full_name) orelse return error.NoSuchMethodError;
    }

    try m.invoke(target, args.items);
}
