const std = @import("std");
const print_answer = @import("./utils/print.zig").print_answer;

const split = std.mem.split;
const indexOf = std.mem.indexOf;
const parseInt = std.fmt.parseInt;

const Color = enum { red, green, blue };

fn part_1(input: []const u8) !u32 {
    var games_it = split(u8, input, "\n");

    var id_sum: u32 = 0;
    while (games_it.next()) |game| blk: {
        if (game.len == 0) break;
        const colon = indexOf(u8, game, ":").?;
        const rounds = game[colon + 2 ..];
        var rounds_it = split(u8, rounds, "; ");
        while (rounds_it.next()) |round| {
            var color_it = split(u8, round, ", ");
            while (color_it.next()) |x| {
                const space_index = indexOf(u8, x, " ").?;
                const amount = try parseInt(u32, x[0..space_index], 10);
                const color = std.meta.stringToEnum(Color, x[space_index + 1 ..]).?;
                if (too_big(amount, color)) break :blk;
            }
        }
        id_sum += try parseInt(u32, game[5..colon], 10);
    }
    return id_sum;
}

fn part_2(input: []const u8) !u32 {
    var games_it = split(u8, input, "\n");

    var powers_sum: u32 = 0;

    while (games_it.next()) |game| {
        if (game.len == 0) break;

        const colon = indexOf(u8, game, ":").?;
        const rounds = game[colon + 2 ..];
        var rounds_it = split(u8, rounds, "; ");

        var min_red: u32 = 0;
        var min_green: u32 = 0;
        var min_blue: u32 = 0;
        while (rounds_it.next()) |round| {
            var color_it = split(u8, round, ", ");
            while (color_it.next()) |x| {
                const space_index = indexOf(u8, x, " ").?;
                const amount = try parseInt(u32, x[0..space_index], 10);
                const color = std.meta.stringToEnum(Color, x[space_index + 1 ..]).?;
                switch (color) {
                    .red => min_red = @max(amount, min_red),
                    .green => min_green = @max(amount, min_green),
                    .blue => min_blue = @max(amount, min_blue),
                }
            }
        }
        powers_sum += (min_red * min_green * min_blue);
    }
    return powers_sum;
}

fn too_big(amount: u32, color: Color) bool {
    return switch (color) {
        .red => amount > 12,
        .green => amount > 13,
        .blue => amount > 14,
    };
}

pub fn main() !void {
    const input = @embedFile("./inputs/day_02.txt");

    print_answer(1, part_1(input));
    print_answer(2, part_2(input));
}

test "day 2" {
    const input =
        \\Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        \\Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        \\Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        \\Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        \\Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
        \\
    ;

    try std.testing.expectEqual(part_1(input), 8);
    try std.testing.expectEqual(part_2(input), 2286);
}
