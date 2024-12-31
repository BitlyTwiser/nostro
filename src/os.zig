const std = @import("std");
const builtin = @import("builtin");

pub var isPosix: ?bool = false;

pub const osTree = struct {
    const Self = @This();

    pub fn init() !Self {
        return Self{};
    }

    pub fn setArch(self: Self) void {
        _ = self;
        switch (builtin.os.tag) {
            .linux, .macos, .openbsd, .netbsd, .freebsd, .kfreebsd, .solaris, .hurd, .dragonfly => {
                isPosix = true;
            },
            .windows => {
                isPosix = false;
            },
            else => {
                isPosix = null;
            },
        }
    }
};
