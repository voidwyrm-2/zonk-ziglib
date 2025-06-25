const std = @import("std");

export fn zputs(mem: [*c]c_char, size: c_ulong, ptr: *c_ulong) callconv(.C) c_char {
    var str = std.ArrayList(u8).init(std.heap.page_allocator);
    defer str.deinit();

    for (ptr.*..size) |i| {
        if (mem[i] == 0)
            break;

        str.append(@intCast(mem[i])) catch return 1;
    }

    std.debug.print("{s}\n", .{str.items});

    return 0;
}
