const std = @import("std");

const name = "zzonklib";

pub fn build(b: *std.Build) !void {
    const so = b.addSharedLibrary(.{
        .name = name,
        .root_source_file = b.path("src/root.zig"),
        .target = b.standardTargetOptions(.{}),
        .optimize = b.standardOptimizeOption(.{}),
    });

    b.installArtifact(so);

    const rename_lib = b.addSystemCommand(&.{ "mv", "zig-out/lib/lib" ++ name ++ ".dylib", "zig-out/lib/" ++ name ++ ".so" });
    rename_lib.step.dependOn(b.getInstallStep());

    const build_step = b.step("b", "");
    build_step.dependOn(&rename_lib.step);
}
