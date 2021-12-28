-- Used to extend default lua implementations
-- https://gist.github.com/HoraceBury/9307117

table.contains = function(tbl, ...)
    local count = 0
    for i = 1, #tbl do
        for c = 1, #arg do
            if (tbl[i] == arg[c]) then
                count = count + 1
            end
        end
    end
    return count >= #arg
end
