# Ada-Zig
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

## Development
See `zig build --list`.
