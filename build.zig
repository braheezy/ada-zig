const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const version = getVersionFromZon();

    // Get upstream Ada library
    const ada_dep = b.dependency("ada", .{
        .optimize = optimize,
        .target = target,
    });

    const options = b.addOptions();
    options.addOption([]const u8, "package_version", b.fmt("{d}.{d}.{d}", .{
        version.major,
        version.minor,
        version.patch,
    }));

    const lib = b.addLibrary(.{
        .name = "adazig",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/ada.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    const ada_artifact = ada_dep.artifact("ada");

    const ada_mod = b.addModule("ada", .{ .root_source_file = b.path("src/ada.zig") });
    ada_mod.linkLibrary(ada_artifact);
    ada_mod.addOptions("build_options", options);

    lib.linkLibrary(ada_artifact);
    lib.root_module.addOptions("build_options", options);
    b.installArtifact(lib);

    // Creates a step for unit testing. This only builds the test executable
    // but does not run it.
    const lib_unit_tests = b.addTest(.{ .root_module = b.createModule(.{
        .root_source_file = b.path("src/ada.zig"),
        .target = target,
        .optimize = optimize,
    }) });

    lib_unit_tests.linkLibrary(ada_dep.artifact("ada"));
    lib_unit_tests.root_module.addOptions("build_options", options);

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

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
    var a3 = .{ "python3", "-m", "http.server", "-d", "docs/" };
    const serve_run = b.addSystemCommand(&a3);
    serve_step.dependOn(&install_docs.step);
    serve_step.dependOn(&serve_run.step);
}

fn getVersionFromZon() std.SemanticVersion {
    const build_zig_zon = @embedFile("build.zig.zon");
    var buffer: [10 * build_zig_zon.len]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const version = std.zon.parse.fromSlice(
        struct { version: []const u8 },
        fba.allocator(),
        build_zig_zon,
        null,
        .{ .ignore_unknown_fields = true },
    ) catch @panic("Invalid build.zig.zon!");
    const semantic_version = std.SemanticVersion.parse(version.version) catch @panic("Invalid version!");
    return std.SemanticVersion{
        .major = semantic_version.major,
        .minor = semantic_version.minor,
        .patch = semantic_version.patch,
        .build = null, // dont return pointers to stack memory
        .pre = null, // dont return pointers to stack memory
    };
}
