// Just parse through each directory recursilvey and look for a given file name that either matches exactly (std.mem.eql or contains std.mem.contains)
const std = @import("std");
const cli = @import("cli.zig").raw;
const mvzr = @import("mvzr");
const bultin = @import("builtin");
const os_tree = @import("os.zig");
const ansi = @import("ansi.zig");

pub const Search = struct {
    allocator: std.mem.Allocator,
    parsed_cli: cli,
    match_indicies: [2]usize,
    match_str: []const u8 = "",
    match_str_raw: []const u8 = "",

    const Self = @This();

    // Can this be done with Zero allocations?
    pub fn init(allocator: std.mem.Allocator, parsed_cli: cli) !Self {
        return Self{
            .allocator = allocator,
            .parsed_cli = parsed_cli,
            .match_indicies = [2]usize{ 0, 0 }, // Start and end incidies for the sector of data to color for matches
        };
    }

    pub fn searchForInputStringWindows(self: *Self) !void {
        if (self.parsed_cli.path) |p| {
            return try self.search(p);
        }

        // Root win path
        try self.search("C:\\");
    }

    // All machines that are not windows, i.e. macOS and Linux
    pub fn searchForInputStringPosix(self: *Self) !void {
        if (self.parsed_cli.path) |p| {
            return try self.search(p);
        }

        // Root *nix path
        try self.search("/");
    }

    fn search(self: *Self, directory_path: []const u8) !void {
        const f_options = std.fs.Dir.OpenDirOptions{ .iterate = true, .access_sub_paths = true };
        const directory = try std.fs.openDirAbsolute(directory_path, f_options);

        var walker = try directory.walk(self.allocator);

        while (try walker.next()) |inner_path| {
            var match_found: bool = false;
            switch (inner_path.kind) {
                .file => {
                    // Check file name
                    if (!self.parsed_cli.fileSearch()) continue;

                    match_found = try self.match(inner_path.basename);
                },
                .directory => {
                    if (self.parsed_cli.fileSearch()) continue;

                    // Else check directory entry name against search
                    match_found = try self.match(inner_path.basename);
                },
                else => {
                    continue;
                },
            }

            if (match_found) {
                const start = std.mem.indexOf(u8, inner_path.path, self.match_str_raw);
                const end = start.? + self.match_str_raw.len;

                const full_path = try std.fmt.allocPrint(self.allocator, "{s}{s}{s}\n", .{ inner_path.path[0..start.?], self.match_str, inner_path.path[end..inner_path.path.len] });
                std.debug.print("{s}", .{full_path});
            }
        }
    }

    // Match will check all conditions for a pattern match to denote a found input string
    fn match(self: *Self, match_value: []const u8) !bool {
        if (self.parsed_cli.i) |lowercase| {
            if (lowercase) _ = std.ascii.lowerString(@constCast(self.parsed_cli.term), self.parsed_cli.term);
            _ = std.ascii.lowerString(@constCast(match_value), match_value);
        }

        const match_contains = std.mem.containsAtLeast(u8, match_value, 1, self.parsed_cli.term);
        const match_eql = std.mem.eql(u8, match_value, self.parsed_cli.term);
        var match_regex: bool = false;

        // Use regex passed from user into compile and check input string
        if (self.parsed_cli.e) |use_regex| {
            if (!use_regex) match_regex = false;

            const regex = mvzr.compile(self.parsed_cli.term);
            if (regex) |re| {
                match_regex = re.isMatch(match_value);

                if (match_regex) {
                    const owned_match = try re.match(match_value).?.toOwnedMatch(self.allocator);

                    self.match_indicies[0] = owned_match.start;
                    self.match_indicies[1] = owned_match.end;

                    self.match_str = try ansi.colorRed(self.allocator, owned_match.slice);
                    self.match_str_raw = owned_match.slice;
                }
            } else {
                match_regex = false;
            }
        }

        const found = match_contains or match_eql or match_regex;

        if (match_contains or match_eql) {
            const start_index = std.mem.indexOf(u8, match_value, self.parsed_cli.term);
            const end_index = start_index.? + self.parsed_cli.term.len;

            self.match_indicies[0] = start_index.?;
            self.match_indicies[1] = end_index;

            self.match_str = try ansi.colorRed(self.allocator, self.parsed_cli.term);
            self.match_str_raw = self.parsed_cli.term;
        }

        return found;
    }
};
