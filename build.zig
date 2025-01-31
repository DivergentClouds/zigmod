const std = @import("std");
const string = []const u8;
const builtin = @import("builtin");
const deps = @import("./deps.zig");

pub fn build(b: *std.build.Builder) void {
    b.prominent_compile_errors = true;
    // currently blocked on https://github.com/ziglang/zig/issues/12403
    b.use_stage1 = !(b.option(bool, "stage2", "use the stage2 compiler") orelse false);
    const target = b.standardTargetOptions(.{});

    b.setPreferredReleaseMode(.ReleaseSafe);
    const mode = b.standardReleaseOptions();

    const use_full_name = b.option(bool, "use-full-name", "") orelse false;
    const with_arch_os = b.fmt("-{s}-{s}", .{ @tagName(target.cpu_arch orelse builtin.cpu.arch), @tagName(target.os_tag orelse builtin.os.tag) });
    const exe_name = b.fmt("{s}{s}", .{ "zigmod", if (use_full_name) with_arch_os else "" });
    const exe = b.addExecutable(exe_name, "src/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);

    const exe_options = b.addOptions();
    exe.addOptions("build_options", exe_options);
    exe_options.addOption(string, "version", b.option(string, "tag", "") orelse "dev");

    deps.addAllTo(exe);
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
