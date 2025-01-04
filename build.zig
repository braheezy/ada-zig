const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Get upstream Ada library
    const ada_dep = b.dependency("ada", .{
        .optimize = optimize,
        .target = target,
    });

    const lib = b.addStaticLibrary(.{
        .name = "ada-zig",
        .root_source_file = b.path("src/ada.zig"),
        .target = target,
        .optimize = optimize,
    });
    const ada_artifact = ada_dep.artifact("ada");

    const ada_mod = b.addModule("ada", .{ .root_source_file = b.path("src/ada.zig") });
    ada_mod.linkLibrary(ada_artifact);

    lib.linkLibrary(ada_artifact);
    b.installArtifact(lib);

    // Creates a step for unit testing. This only builds the test executable
    // but does not run it.
    const lib_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/ada.zig"),
        .target = target,
        .optimize = optimize,
    });

    lib_unit_tests.linkLibrary(ada_dep.artifact("ada"));

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    // Similar to creating the run step earlier, this exposes a `test` step to
    // the `zig build --help` menu, providing a way for the user to request
    // running the unit tests.
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);

    const install_docs = b.addInstallDirectory(.{
        .source_dir = lib.getEmittedDocs(),
        .install_dir = .{ .custom = "../docs" },
        .install_subdir = "",
    });

    const docs_step = b.step("docs", "Copy documentation artifacts to prefix path");
    docs_step.dependOn(&install_docs.step);

    const serve_step = b.step("serve", "Serve documentation");
    var a3 = .{ "python", "-m", "http.server", "-d", "docs/" };
    const serve_run = b.addSystemCommand(&a3);
    serve_step.dependOn(&install_docs.step);
    serve_step.dependOn(&serve_run.step);
}
