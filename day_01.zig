const std = @import("std");
const print_answer = @import("./utils/print.zig").print_answer;

const values = [_][]const u8{ "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "1", "2", "3", "4", "5", "6", "7", "8", "9" };

const Tag = enum(u8) {
    one = '1',
    two = '2',
    three = '3',
    four = '4',
    five = '5',
    six = '6',
    seven = '7',
    eight = '8',
    nine = '9',
};
fn part_1(input: []const u8) !usize {
    return find_calibration_value(input, false);
}

fn part_2(input: []const u8) !usize {
    return find_calibration_value(input, true);
}

fn find_calibration_value(input: []const u8, use_text: bool) !usize {
    var calibrations_it = std.mem.split(u8, input, "\n");
    var total: usize = 0;
    while (calibrations_it.next()) |x| {
        if (x.len > 0) {
            const calibration_value = if (use_text)
                [2]u8{ find_text_digit(x, true), find_text_digit(x, false) }
            else
                [2]u8{ find_digit(x, true), find_digit(x, false) };
            total += try std.fmt.parseInt(usize, &calibration_value, 10);
        }
    }

    return total;
}

fn find_text_digit(str: []const u8, first: bool) u8 {
    var current_tag: u8 = 0;
    var current_index: usize = if (first) std.math.maxInt(usize) else 0;
    for (values) |value| {
        const optional_x = if (first)
            std.mem.indexOf(u8, str, value)
        else
            std.mem.lastIndexOf(u8, str, value);

        if (optional_x) |x| {
            if ((first and x < current_index) or (!first and x >= current_index)) {
                current_index = x;

                if (std.meta.stringToEnum(Tag, value)) |tag| {
                    current_tag = @intFromEnum(tag);
                } else {
                    current_tag = value[0];
                }
            }
        }
    }
    return current_tag;
}

fn find_digit(str: []const u8, first: bool) u8 {
    return for (str, 1..) |x, idx| {
        const char = if (first) x else str[str.len - idx];
        if (std.ascii.isDigit(char)) break char;
    } else blk: {
        break :blk 0;
    };
}

pub fn main() !void {
    const input = @embedFile("./inputs/day_01.txt");

    print_answer(1, part_1(input));
    print_answer(2, part_2(input));
}

test "part 1" {
    const input =
        \\1abc2
        \\pqr3stu8vwx
        \\a1b2c3d4e5f
        \\treb7uchet
        \\
    ;

    try std.testing.expectEqual(part_1(input), 142);
}

test "part 2" {
    const input =
        \\two1nine
        \\eightwothree
        \\abcone2threexyz
        \\xtwone3four
        \\4nineeightseven2
        \\zoneight234
        \\7pqrstsixteen
        \\
    ;

    try std.testing.expectEqual(part_2(input), 281);
}
