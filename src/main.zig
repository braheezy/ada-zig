const std = @import("std");

const ada = @import("ada.zig");

pub fn main() !void {
    const input_url = "https://user:pass@127.0.0.1:8080/path?query=1#frag";

    const url = try ada.Url.init(input_url);
    defer url.free();

    std.debug.print("url.host type: {any}\n", .{url.getHostType()});
}
