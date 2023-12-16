const std = @import("std");

pub fn nextNumber(parser: *std.fmt.Parser) ?usize {
    if (parser.pos >= parser.buf.len)
        return null;

    while (parser.pos < parser.buf.len) : (parser.pos += 1) {
        if (std.ascii.isDigit(parser.buf[parser.pos])) break;
    } else {
        return null;
    }

    return parser.number().?;
}
