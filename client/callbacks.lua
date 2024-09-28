lib.callback.register("gigo-trucking:client:RandomJob", function ()
    local selected = {}
    local tempList = {}

    for i,a in ipairs do
        table.insert(tempList, a)
    end

    for i = 1,3 do
        if #tempList == 0 then
            break
        end

        local randIndex = math.random(1, #tempList)
        table.insert(selected, table.remove(tempList, randIndex))
    end

    return selected
end)