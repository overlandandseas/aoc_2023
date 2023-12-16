const std = @import("std");
const Parser = std.fmt.Parser;
const print_answer = @import("./utils/print.zig").print_answer;
const nextNumber = @import("./utils/parser.zig").nextNumber;

const PartData = struct { winnings_start: usize, lotto_start: usize, storage_buffer: std.mem.Allocator, len: usize };

fn part1(input: []const u8, data: PartData) !usize {
    var lines_it = std.mem.split(u8, input, "\n");
    var total: usize = 0;

    while (lines_it.next()) |line| {
        var parser = Parser{ .buf = line, .pos = data.winnings_start };
        var card_total: usize = 0;

        var winning_numbers = std.AutoHashMap(usize, void).init(data.storage_buffer);
        defer winning_numbers.deinit();

        while (nextNumber(&parser)) |num| {
            if (parser.pos <= data.lotto_start) {
                try winning_numbers.put(num, {});
            } else if (winning_numbers.contains(num)) {
                card_total += if (card_total == 0) 1 else card_total;
            }
        }
        total += card_total;
    }
    return total;
}

fn part2(input: []const u8, comptime data: PartData) !usize {
    var lines_it = std.mem.split(u8, input, "\n");
    var scratch_cards: @Vector(data.len, usize) = @splat(0);
    var game: usize = 0;

    while (lines_it.next()) |line| : (game += 1) {
        if (line.len == 0) break;

        var wins: usize = 0;
        var parser = Parser{ .buf = line, .pos = data.winnings_start };

        var winning_numbers = std.AutoHashMap(usize, void).init(data.storage_buffer);
        defer winning_numbers.deinit();

        scratch_cards[game] = scratch_cards[game] + 1;

        while (nextNumber(&parser)) |num| {
            if (parser.pos <= data.lotto_start) {
                try winning_numbers.put(num, {});
            } else if (winning_numbers.contains(num)) {
                wins += 1;
                scratch_cards[game + wins] = scratch_cards[game + wins] + scratch_cards[game];
            }
        }
    }
    return @reduce(.Add, scratch_cards);
}

pub fn main() !void {
    const input = @embedFile("./inputs/day_04.txt");

    const data = .{
        .winnings_start = 9,
        .lotto_start = 40,
        .len = 197,
        .storage_buffer = std.heap.page_allocator,
    };

    print_answer(1, part1(input, data));
    print_answer(2, part2(input, data));
}

test "Day 4" {
    const input =
        \\Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
        \\Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
        \\Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
        \\Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
        \\Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
        \\Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
        \\
    ;

    const testing_data = .{
        .winnings_start = 7,
        .lotto_start = 23,
        .len = 6,
        .storage_buffer = std.testing.allocator,
    };

    try std.testing.expectEqual(try part1(input, testing_data), 13);
    try std.testing.expectEqual(try part2(input, testing_data), 30);
}
