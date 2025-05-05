# Ada Zig

[![docs](/assets/zig.svg)](https://braheezy.github.io/ada-zig)

[Ada](https://github.com/ada-url/ada) is a fast and spec-compliant URL parser written in C++. Specification for URL parser can be found from the WHATWG website.

This project contains Zig language bindings. That means instead of linking the C library directly in your project and interacting with the C API, `adazig` does it for you, providing a thin wrapper for familiar Zig use.

If you want to interact with the C more directly but still consume it using the Zig build system, see the [Ziggified build of Ada](https://github.com/braheezy/ada).

## Usage

First, add to your `build.zig.zon`:

```bash
zig fetch --save git+https://github.com/braheezy/ada-zig#3.2.4
```

Then update your `build.zig`:

```zig
const ada_dep = b.dependency("adazig", .{});
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

There's also [Zig docs](https://braheezy.github.io/ada-zig) for the package.

## Development

See `zig build --list`.
