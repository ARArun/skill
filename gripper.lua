bat_total = 10000
bat_cur = 10000
es = 0
--------------------------------------------------------------------------------
function init()
    self_addr = addr(robot.id)
    log(robot.id," = ",id)
    state = "search"
    prev_state = "dummy"
end
--------------------------------------------------------------------------------
function step()
    --[[if (bat_cur/bat_total) > 0.25 then
        robot.leds.set_all_colors(0,255,255)
    else
        robot.leds.set_all_colors(255,0,0)
    end]]--
    robot.leds.set_all_colors(0,255,255)

end

--------------------------------------------------------------------------------
function reset()
end
function destroy()
    log('Energy spent by ',robot.id,' / ',id,' = ',es,'\n')
end
--------------------------------------------------------------------------------
------------------------address determining function----------------------------
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
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
