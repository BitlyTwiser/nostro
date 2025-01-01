const std = @import("std");

pub const raw = struct {
    term: []const u8, // Primary search value - Only truly required value
    path: ?[]const u8, // The path to start the search. If not present, the application starts from / or C:/
    t: []const u8 = "f",
    e: ?bool, // If using a regular expression
    i: ?bool, // Case insensitive

    const Self = @This();

    pub fn fileSearch(self: Self) bool {
        return std.mem.eql(u8, self.t, "f");
    }
};
