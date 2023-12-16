const std = @import("std");
const Parser = std.fmt.Parser;
const print_answer = @import("./utils/print.zig").print_answer;
const nextNumber = @import("./utils/parser.zig").nextNumber;
const Tuple = std.meta.Tuple;

const MagicData = struct {
    seed_to_soil: Tuple(&.{ usize, usize }),
    soil_to_fertilizer: Tuple(&.{ usize, usize }),
    fertilizer_to__water: Tuple(&.{ usize, usize }),
    water_to_light: Tuple(&.{ usize, usize }),
    light_to_temperature: Tuple(&.{ usize, usize }),
    temperature_to_humidity: Tuple(&.{ usize, usize }),
    humidity_to_location: Tuple(&.{ usize, usize }),
};

fn part1(input: []const u8, comptime data: MagicData) usize {
    _ = data;

    var lines_it = std.mem.split(u8, input, "\n");

    const numbers = lines_it.first();

    var num_parser = Parser{ .buf = numbers };

    var min: usize = std.math.maxInt(usize);
    while (nextNumber(&num_parser)) |num| {
        std.debug.print("see tweets: {d}\n", .{num});

        min = @min(min, num);
    }

    return min;
}

test "Day 5" {
    const input =
        \\seeds: 79 14 55 13
        \\
        \\seed-to-soil map:
        \\50 98 2
        \\52 50 48
        \\
        \\soil-to-fertilizer map:
        \\0 15 37
        \\37 52 2
        \\39 0 15
        \\
        \\fertilizer-to-water map:
        \\49 53 8
        \\0 11 42
        \\42 0 7
        \\57 7 4
        \\
        \\water-to-light map:
        \\88 18 7
        \\18 25 70
        \\
        \\light-to-temperature map:
        \\45 77 23
        \\81 45 19
        \\68 64 13
        \\
        \\temperature-to-humidity map:
        \\0 69 1
        \\1 0 69
        \\
        \\humidity-to-location map:
        \\60 56 37
        \\56 93 4
        \\
    ;

    const magic_data = .{
        .seed_to_soil = .{ 3, 4 },
        .soil_to_fertilizer = .{ 7, 9 },
        .fertilizer_to__water = .{ 12, 15 },
        .water_to_light = .{ 18, 19 },
        .light_to_temperature = .{ 22, 24 },
        .temperature_to_humidity = .{ 27, 28 },
        .humidity_to_location = .{ 31, 32 },
    };

    try std.testing.expectEqual(part1(input, magic_data), 35);
}
