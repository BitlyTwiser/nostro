const std = @import("std");
const snek = @import("snek");
const cli = @import("cli.zig").raw;
const search = @import("search.zig").Search;
const builtin = @import("builtin");
const os_tree = @import("os.zig");
const tree = @import("os.zig").osTree;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = arena.allocator();
    defer arena.deinit();

    // Parse CLI
    var p = try snek.Snek(cli).init(allocator);
    const parsed_cli = try p.parse();

    var s = try search.init(allocator, parsed_cli);

    // Set working architecture
    const os = try tree.init();
    os.setArch();

    if (os_tree.isPosix) |posix| {
        if (posix) {
            return try s.searchForInputStringPosix();
        }

        return try s.searchForInputStringWindows();
    } else {
        std.debug.print("Non-supported OS type, please ensure you are on macOS, Linux, or a windows based system.", .{});
        return;
    }
}
