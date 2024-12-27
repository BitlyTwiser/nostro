// Just parse through each directory recursilvey and look for a given file name that either matches exactly (std.mem.eql or contains std.mem.contains)
const std = @import("std");
const cli = @import("cli.zig").raw;

pub const Search = struct {
    allocator: std.mem.Allocator,
    parsed_cli: cli,

    const Self = @This();

    // Can this be done with Zero allocations?
    pub fn init(allocator: std.mem.Allocator, parsed_cli: cli) !Self {
        return Self{
            .allocator = allocator,
            .parsed_cli = parsed_cli,
        };
    }

    pub fn searchForInputString(self: *Self) !void {
        std.debug.print("Searching for value {s}", .{self.parsed_cli.term});
        // Recusively search for file

        std.fs.Dir.walk();
        // Compare final iterations against the entire corpus of linux kernel code and test against ripgrep times

    }

    // All machines that are not windows, i.e. macOS and Linux
    pub fn searchForInputStringPosix(self: Self) !void {
        std.debug.print("Searching for value {s} on posix system", .{self.parsed_cli.term});
    }
};
