const std = @import("std");
const snek = @import("snek");
const cli = @import("cli.zig").raw;
const search = @import("search.zig").Search;
const builtin = @import("builtin");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = arena.allocator();
    defer arena.deinit();

    // Parse CLI
    var p = try snek.Snek(cli).init(allocator);
    const parsed_cli = try p.parse();

    var s = try search.init(allocator, parsed_cli);

    switch (builtin.os.tag) {
        // Further extend this list later
        .linux, .macos, .openbsd, .netbsd, .freebsd, .kfreebsd, .solaris, .hurd, .dragonfly => {
            try s.searchForInputStringPosix();
        },
        .windows => {
            try s.searchForInputString();
        },
        else => {
            std.debug.print("Non-supported OS type, please ensure you are on macOS, Linux, or a windows based system.", .{});
            return;
        },
    }
}
