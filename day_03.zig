const std = @import("std");
const Parser = std.fmt.Parser;
const print_answer = @import("./utils/print.zig").print_answer;
const EngineNumber = struct {
    start: usize,
    end: usize,
    value: usize,
};

fn part_1(input: []const u8) usize {
    const len = std.mem.indexOfScalar(u8, input, '\n').? + 1;

    var parser = Parser{
        .buf = input,
    };

    var total: usize = 0;

    blk: while (nextEngine(&parser, null)) |n| {
        // top row
        if (n.start > len) {
            for (@max(0, n.start - len - 1)..n.end - len + 1) |idx| {
                if (isSymbol(input[idx])) {
                    total += n.value;
                    continue :blk;
                }
            }
        }

        // middle row
        for (if (n.start > 0) n.start - 1 else 0..@min(n.end + 1, input.len)) |idx| {
            if (isSymbol(input[idx])) {
                total += n.value;
                continue :blk;
            }
        }

        //bottom row
        if (n.end < input.len - len) {
            for (n.start + len - 1..@min(input.len, n.end + len + 1)) |idx| {
                if (isSymbol(input[idx])) {
                    total += n.value;
                    continue :blk;
                }
            }
        }
    }

    return total;
}

fn part2(input: []const u8) usize {
    const len = std.mem.indexOfScalar(u8, input, '\n').? + 1;

    var parser = Parser{
        .buf = input,
    };
    var total: usize = 0;

    gear: while (nextGear(&parser)) |x| {
        defer parser.pos = x + 1;

        var count: u8 = 0;
        var product: usize = 1;

        const start, const end = blk: {
            const row = x / len;
            break :blk .{
                (if (row == 0) 0 else row - 1) * len,
                (if (x > input.len - len) row else row + 2) * len,
            };
        };

        parser.pos = start;
        eng: while (nextEngine(&parser, end)) |n| {
            if (
            // top row
            //     start
            (n.start >= x - len - 1 and n.start <= x - len + 1)
            //     end
            or (n.end - 1 >= x - len - 1 and n.end - 1 <= x - len + 1)
            // middle row
            //     start
            or n.start == x + 1
            //     end
            or n.end - 1 == x - 1
            // bottom row
            //     start
            or (n.start >= x + len - 1 and n.start <= x + len + 1)
            //     end
            or (n.end - 1 >= x + len - 1 and n.end - 1 <= x + len + 1)) {
                if (count == 2) continue :gear; // too many numbers
                count += 1;
                product *= n.value;
                continue :eng;
            }
        }

        // valid gear
        if (count == 2) total += product;
    }
    return total;
}

fn isSymbol(c: u8) bool {
    return !std.ascii.isDigit(c) and c != '.' and c != '\n';
}

fn nextGear(parser: *Parser) ?usize {
    const start = parser.pos;

    if (start >= parser.buf.len)
        return null;

    while (parser.pos < parser.buf.len) {
        if (parser.buf[parser.pos] == '*') break else parser.pos += 1;
    } else {
        return null;
    }

    return parser.pos;
}

fn nextEngine(parser: *Parser, until: ?usize) ?EngineNumber {
    const start = parser.pos;

    const end = if (until) |x| x else parser.buf.len;

    if (start >= end)
        return null;

    while (parser.pos < end) : (parser.pos += 1) {
        if (std.ascii.isDigit(parser.buf[parser.pos])) break;
    } else {
        return null;
    }

    return .{ .start = parser.pos, .value = parser.number().?, .end = parser.pos };
}

pub fn main() !void {
    const input = @embedFile("./inputs/day_03.txt");

    print_answer(1, part_1(input));
    print_answer(2, part2(input));
}

test "day 3" {
    const input =
        \\467..114..
        \\...*......
        \\..35..633.
        \\......#...
        \\617*......
        \\.....+.58.
        \\..592.....
        \\......755.
        \\...$.*....
        \\.664.598..
        \\
    ;

    try std.testing.expectEqual(part_1(input), 4361);
    try std.testing.expectEqual(part2(input), 467835);
}
