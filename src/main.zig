const std = @import("std");

const ada = @import("ada.zig");

pub fn main() !void {
    // var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    // const allocator = gpa.allocator();
    // defer if (gpa.deinit() == .leak) {
    //     std.process.exit(1);
    // };

    const input_url = "https://user:pass@127.0.0.1:8080/path?query=1#frag";

    const url = try ada.Url.init(input_url);
    defer url.free();

    std.debug.print("url.host type: {any}\n", .{url.getHostType()});
}
