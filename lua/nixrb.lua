local args = { ... }
if args[0] == "--" then
    table.remove(args, 0)
end

for i, v in ipairs(args) do
    print(v)
end

print("hello")
