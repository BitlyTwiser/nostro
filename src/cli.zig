pub const raw = struct {
    term: []const u8, // Primary search value - Only truly required value
    path: []const u8, // The path to start the search. If not present, the application starts from / or C:/
    e: ?[]const u8, // regex search
    i: ?bool, // Case insensitive
    p: ?[]const u8, // Start with string (prefix)
    s: ?[]const u8, // Ends with string (suffix)
};
