# Ada-Zig
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="108" height="20" role="img" aria-label="zig reference">
  <a xlink:href="https://braheezy.github.io/ada-zig/">
  <title>zig reference</title>
  <linearGradient id="a" x2="0" y2="100%">
    <stop offset="0" stop-color="#fff" stop-opacity=".7"/>
    <stop offset="0.7" stop-color="#fff" stop-opacity=".1"/>
  </linearGradient>
  <rect rx="3" width="108" height="20" fill="#555"/>
  <rect rx="3" x="37" width="71" height="20" fill="#f7a41d"/>
  <path stroke="#f7a41d" stroke-width="2" d="M37 0h4v20h-4z" fill="#f7a41d"/>
  <rect rx="3" width="108" height="20" fill="url(#a)"/>
  <g fill="#fff" text-anchor="middle" font-family="DejaVu Sans,Verdana,Geneva,sans-serif" font-size="11">
    <text x="19" y="15">zig</text>
    <text x="72" y="15">reference</text>
  </g>
</svg>


[Ada](https://github.com/ada-url/ada) is a fast and spec-compliant URL parser written in C++. Specification for URL parser can be found from the WHATWG website.

This project contains Zig language bindings. That means instead of linking the C library directly in your project and interacting with the C API, `zig-ada` does it for you, providing a thin wrapper for familiar Zig use.

## Usage
First, add to your `build.zig.zon`:
```bash
zig fetch --save git+https://github.com/braheezy/ada-zig#2.9.2
```

Then update your `build.zig`:

```zig
const ada_dep = b.dependency("ada-zig", .{});
exe.root_module.addImport("ada", ada_dep.module("ada"));
```

Finally, in your source code:

```zig
const ada = @import("ada");

pub fn main() void {
    const ada_url = try ada.Url.init("https://ziglang.org/");

    std.debug.print(ada_url.getProtocol());
    // prints 'https'
}
```

## Examples

The [Usage docs](https://github.com/ada-url/ada/tree/main?tab=readme-ov-file#usage) from the Ada library are applicable.

```zig
const std = @import("std");

const ada = @import("ada");

pub fn main() !void {
    const input_url = "https://user:pass@127.0.0.1:8080/path?query=1#frag";

    const url = try ada.Url.init(input_url);
    defer url.free();

    std.debug.print("url.host type: {any}\n", .{url.getHostType()});
}
```

## Development
See `zig build --list`.
