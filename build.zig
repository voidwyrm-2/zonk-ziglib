const std = @import("std");

const name = "zzonklib";

const system_lib_ext = switch (@import("builtin").os.tag) {
    .windows => ".dll",
    .macos => ".dylib",
    .wasi, .emscripten => ".wasm",
    else => ".so",
};

pub fn build(b: *std.Build) !void {
    const so = b.addSharedLibrary(.{
        .name = name,
        .root_source_file = b.path("src/root.zig"),
        .target = b.standardTargetOptions(.{}),
        .optimize = b.standardOptimizeOption(.{}),
    });

    b.installArtifact(so);

    const rename_lib = b.addSystemCommand(&.{ "mv", "zig-out/lib/lib" ++ name ++ system_lib_ext, "zig-out/lib/" ++ name ++ system_lib_ext });
    rename_lib.step.dependOn(b.getInstallStep());

    const build_step = b.step("b", "");
    build_step.dependOn(&rename_lib.step);
}
