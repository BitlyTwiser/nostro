const std = @import("std");

//ansi escape codes
const esc = "\x1B";
const csi = esc ++ "[";

// Colors:
const color_reset = csi ++ "0m";

const color_red = csi ++ "31m"; // red
const color_italic = csi ++ "3m";
const color_not_italic = csi ++ "23m";

pub fn colorRed(allocator: std.mem.Allocator, a: anytype) ![]const u8 {
    return try std.fmt.allocPrint(allocator, "{s}{s}{s}", .{ color_red, a, color_reset });
}
