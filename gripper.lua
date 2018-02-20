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
    if (bat_cur/bat_total) > 0.25 then
        robot.leds.set_all_colors(0,255,255)
    else
        robot.leds.set_all_colors(255,0,0)
    end
    if state == "search" then
        search()
    end
end

--------------------------------------------------------------------------------
function reset()
end
function destroy()
    log('Energy spent by gripper ',id,' = ',es)
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
function search()
    bat_cur = bat_cur - 10
    es = es + 10
    sensingLeft =     robot.proximity[3].value +
                      robot.proximity[4].value +
                      robot.proximity[5].value +
                      robot.proximity[6].value +
                      robot.proximity[2].value +
                      robot.proximity[1].value

    sensingRight =    robot.proximity[19].value +
                      robot.proximity[20].value +
                      robot.proximity[21].value +
                      robot.proximity[22].value +
                      robot.proximity[24].value +
                      robot.proximity[23].value
    if bat_cur <= (30/100) * bat_total then
        state = "to_charge"
    end
    if sensingLeft ~= 0 then
          robot.wheels.set_velocity(7,3)
    elseif sensingRight ~= 0 then
          robot.wheels.set_velocity(3,7)
    else
          robot.wheels.set_velocity(10,10)
    end
end
--------------------------------------------------------------------------------
