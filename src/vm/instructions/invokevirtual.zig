const std = @import("std");
const vm = @import("../vm.zig");
const Variable = @import("../variable.zig").Variable;
const variable = @import("../variable.zig");
const ALLOC = @import("../../alloc.zig").ALLOC;
const constant = @import("../../class_file/constant.zig");
const methods = @import("../../class/method.zig");

pub fn invokevirtual(m: *vm.Vm, mref_idx: u16) !void {
    var args = std.ArrayList(Variable).init(ALLOC);
    var objectref: variable.ObjectRef = undefined;

    const s = try m.get_storage();

    s.dump();

    while (true) {
        const arg = try s.pop();

        if (@as(variable.Type, arg) == variable.Type.objectref) {
            objectref = arg.objectref;
        }

        try args.append(arg);
    }

    if (objectref == undefined) {
        return error.NullPointerException;
    }

    var class = try m.get_class(objectref.class);

    if (m.current_class == null) {
        return error.NullPointerException;
    }

    const const_items = &m.current_class.?.constant.pool.items;
    if (const_items.len <= mref_idx) {
        return error.IndexOutOfBoundsException;
    }

    const mref = const_items[mref_idx];

    if (@as(constant.ConstantTag, mref) != constant.ConstantTag.method_ref) {
        return error.IncompatibleClassChangeError;
    }

    const method = mref.method_ref;

    if (const_items.len <= method.class_index) {
        return error.IndexOutOfBoundsException;
    }

    const class_name_const = const_items[method.class_index];

    if (@as(constant.ConstantTag, class_name_const) != constant.ConstantTag.class) {
        return error.IncompatibleClassChangeError;
    }

    const class_name_idx = class_name_const.class.name_index;

    if (const_items.len <= class_name_idx) {
        return error.IndexOutOfBoundsException;
    }

    const class_name = try m.current_class.?.constant.get_utf8(class_name_idx);

    if (!class.name.is_slice(class_name)) {
        return error.IncompatibleClassChangeError;
    }

    if (const_items.len <= method.name_and_type_index) {
        return error.IndexOutOfBoundsException;
    }

    const method_name_type = const_items[method.name_and_type_index];

    if (@as(constant.ConstantTag, method_name_type) != constant.ConstantTag.name_and_type) {
        return error.IncompatibleClassChangeError;
    }

    const name = try m.current_class.?.constant.get_utf8(method_name_type.name_and_type.name_index);
    const descriptor = try m.current_class.?.constant.get_utf8(method_name_type.name_and_type.descriptor_index);

    const full_name = name ++ descriptor;

    var target: *methods.Method = undefined;

    if (objectref.field != null) {
        var field = try class.get_field(objectref.field.?);

        target = try field.get_method(full_name);
    } else {
        target = try class.get_method(full_name);
    }

    m.invoke(target);
}
