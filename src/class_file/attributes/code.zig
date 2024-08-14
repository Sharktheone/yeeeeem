const std = @import("std");
const bytes = @import("bytes");
const attributes = @import("attributes");

pub const CodeAttribute = struct {
    max_stack: u16,
    max_locals: u16,
    exception_table: std.ArrayList(ExceptionTableEntry),
    attributes: std.ArrayList(attributes.AttributeInfo),
};

pub const ExceptionTableEntry = struct {
    start_pc: u16,
    end_pc: u16,
    handler_pc: u16,
    catch_type: u16,

    fn parse(reader: *bytes.Reader) ExceptionTableEntry {
        var this = ExceptionTableEntry{};

        this.start_pc = reader.read_u16();
        this.end_pc = reader.read_u16();
        this.handler_pc = reader.read_u16();
        this.catch_type = reader.read_u16();

        return this;
    }
};

pub fn parse(reader: *bytes.Reader) CodeAttribute {
    var this = CodeAttribute{};

    this.max_stack = reader.read_u16();
    this.max_locals = reader.read_u16();

    const code_length = reader.read_u32();
    this.code = reader.read(code_length);

    const exception_table_length = reader.read_u16();
    this.exception_table = std.ArrayList(ExceptionTableEntry).initCapacity(exception_table_length, exception_table_length);

    for (0..exception_table_length) |_| {
        this.exception_table.append(ExceptionTableEntry.parse(reader));
    }

    this.attributes = attributes.parse_attributes(reader);

    return this;
}
