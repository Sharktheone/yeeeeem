const std = @import("std");
const bytes = @import("../bytes/bytes.zig");

pub const StackMapTable = struct {
    frames: std.ArrayList(StackMaFrame),
};

pub const StackMaFrame = union {
    FrameType: u8,
    SameFrame: struct {
        type: u8, // 0-63
    },
    SameLocals1StackItemFrame: struct {
        type: u8, // 64-127
        stack: VerificationTypeInfo,
    },
    SameLocals1StackItemFrameExtended: struct {
        type: u8, // 247
        offset_delta: u16,
        stack: VerificationTypeInfo,
    },
    ChopFrame: struct {
        type: u8, // 248-250
        offset_delta: u8,
    },
    SameFrameExtended: struct {
        type: u8, // 251
        offset_delta: u16,
    },
    AppendFrame1: struct {
        type: u8, // 252
        offset_delta: u16,
        locals: VerificationTypeInfo,
    },
    AppendFrame2: struct {
        type: u8, // 253
        offset_delta: u16,
        locals: [2]VerificationTypeInfo,
    },
    AppendFrame3: struct {
        type: u8, // 254
        offset_delta: u16,
        locals: [3]VerificationTypeInfo,
    },

    FullFrame: struct {
        type: u8, // 255
        offset_delta: u16,
        locals: std.ArrayList(VerificationTypeInfo),
        stack: std.ArrayList(VerificationTypeInfo),
    },
};

pub const VerificationTypeInfo = union(enum) {
    Top,
    Integer,
    Float,
    Long,
    Double,
    Null,
    UninitializedThis,
    Object: struct {
        cpool_index: u16,
    },
    Uninitialized: struct {
        offset: u16,
    },
};
