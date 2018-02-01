function init()

end

function step()

end

--------------------------------------------------------------------------------
function reset()
end
function destroy()
end
--------------------------------------------------------------------------------
----------------------------------addr fn---------------------------------------
-----------A hash function that decides the address of the robot----------------
--------------------------------------------------------------------------------
function addr(s)
    i = 0
    id = 0
    for c in s:gmatch"." do
        id = id + (string.byte(c) * math.pow(2 , i))
        i = i + 1
    end
    id = math.fmod(id,251) + 1
    return id
end
