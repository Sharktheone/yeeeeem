const std = @import("std");
const vm = @import("../vm.zig");
const Variable = @import("../variable.zig").Variable;
const constant = @import("../../class_file/constant.zig");
const variable = @import("../variable.zig");
const utils = @import("../../utils.zig");

pub fn getstatic(m: *vm.Vm, idx: u16) !void {
    const class = m.current_class orelse return error.missing_class;

    const items = &class.constant;

    const item = try items.get(idx);

    if (@as(constant.ConstantTag, item) != constant.ConstantTag.field_ref) {
        std.debug.print("Expected field_ref, got {} ({})\n", .{ @as(constant.ConstantTag, item), idx });
        return error.invalid_type;
    }

    const field_ref = item.field_ref;

    const name = try utils.String.from_slice(try class.constant.get_class(field_ref.class_index));
    const descriptor = try class.constant.get_full_name(field_ref.name_and_type_index);

    const ref = variable.ObjectRef{
        .class = name,
        .field = try descriptor.clone(),
    };

    try m.push(Variable{ .objectref = ref });
}
