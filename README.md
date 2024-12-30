# Ada-Zig

[Ada](https://github.com/ada-url/ada) is a URL parsing library written in C++. This project contains Zig language bindings.

That means instead of linking the C in your project and interacting directly with the C API, `zig-ada` does it for you, providing a thin wrapper for familiar developer use.

## Usage

- Add to build.zig.zon
- Add to build.zig

## Examples

The [Usage docs](https://github.com/ada-url/ada/tree/main?tab=readme-ov-file#usage) from the Ada library are applicable.
List of things different:

- []const u8 instead of ada_string
- Enums for HostType and SchemeType
- Error types instead of booleans to indicate success.

## Development

- zig build commands
