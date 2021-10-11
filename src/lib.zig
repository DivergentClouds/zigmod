const zfetch = @import("zfetch");

pub const commands_to_bootstrap = struct {
    pub const version = @import("./cmd/version.zig");
    pub const fetch = @import("./cmd/fetch.zig");
    pub const ci = @import("./cmd/ci.zig");
};

pub const commands = struct {
    usingnamespace commands_to_bootstrap;
    pub const init = @import("./cmd/init.zig");
    pub const sum = @import("./cmd/sum.zig");
    pub const zpm = @import("./cmd/zpm.zig");
    pub const license = @import("./cmd/license.zig");
    pub const aq = @import("./cmd/aq.zig");
};

pub fn init() !void {
    try zfetch.init();
}

pub fn deinit() void {
    zfetch.deinit();
}
