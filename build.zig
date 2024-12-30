const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const ada_dep = b.dependency("ada", .{});
    const ada_lib = b.addStaticLibrary(.{
        .name = "ada",
        .optimize = optimize,
        .target = target,
    });

    const c_flags = [_][]const u8{
        "",
    };
    // ada_lib.addCSourceFile(.{ .file = ada_dep.path("ada_c.h"), .flags = &c_flags });
    // ada_lib.addCSourceFile(.{ .file = ada_dep.path("ada.h"), .flags = &c_flags });
    ada_lib.addCSourceFile(.{ .file = ada_dep.path("ada.cpp"), .flags = &c_flags });
    ada_lib.addIncludePath(ada_dep.path("."));

    ada_lib.linkLibCpp();

    const lib = b.addStaticLibrary(.{
        .name = "ada-zig",
        .root_source_file = b.path("src/ada.zig"),
        .target = target,
        .optimize = optimize,
    });
    lib.linkLibrary(ada_lib);
    lib.addIncludePath(ada_dep.path("."));
    b.installArtifact(lib);

    const exe = b.addExecutable(.{
        .name = "ada-zig",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    exe.linkLibrary(lib);
    exe.addIncludePath(ada_dep.path("."));

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    // This creates a build step. It will be visible in the `zig build --help` menu,
    // and can be selected like this: `zig bu
    // This will evaluate the `run` step rather than the default, which is "install".
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    // Creates a step for unit testing. This only builds the test executable
    // but does not run it.
    const lib_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/ada.zig"),
        .target = target,
        .optimize = optimize,
    });

    lib_unit_tests.addIncludePath(ada_dep.path("."));
    lib_unit_tests.linkLibrary(ada_lib);

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    const exe_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    // Similar to creating the run step earlier, this exposes a `test` step to
    // the `zig build --help` menu, providing a way for the user to request
    // running the unit tests.
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
    test_step.dependOn(&run_exe_unit_tests.step);
}
