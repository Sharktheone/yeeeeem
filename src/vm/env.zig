const vm = @import("vm.zig");
const System = @import("env/system.zig");

pub fn init(m: *vm.Vm) !void {
    try System.init(m);
}
