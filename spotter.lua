bat_total = 10000
bat_cur = 10000
decide_check = 0
es = 0
object = "none"
function init()
    self_addr = addr(robot.id)
    log(robot.id," = ",id)
    state = "search"
    prev_state = "dummy"
    robot.colored_blob_omnidirectional_camera.enable()
end

function step()
    --colors
--[[    if (bat_cur/bat_total) > 0.25 then
        robot.leds.set_all_colors(0,0,255)
    else
        robot.leds.set_all_colors(255,0,0)
    end]]--
    robot.leds.set_all_colors(0,0,255)
    if state ~= prev_state then
        log(self_addr,"=",state)
    end
    prev_state = state

    if state == "search" then
        search()
    elseif state == "choose" then
        choose()
    elseif state == "approach" then
        approach()
    elseif state == "decide" then
        decide()
    end

end

--------------------------------------------------------------------------------
function reset()
end
function destroy()
    log('Energy spent by ',robot.id,' / ',id,' = ',es,'\n')
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
--------------------------------------------------------------------------------
-----------------------------function search()----------------------------------
--------------------------------------------------------------------------------
function search()
    --bat_cur = bat_cur - 10
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
    if #robot.colored_blob_omnidirectional_camera ~= 0  then
        for i = 1,#robot.colored_blob_omnidirectional_camera do
            if (robot.colored_blob_omnidirectional_camera[i].color.red == 165 and
                robot.colored_blob_omnidirectional_camera[i].color.green == 42 and
                robot.colored_blob_omnidirectional_camera[i].color.blue == 42) then
                    state = "choose"
                    object = "large_disc"
            elseif(robot.colored_blob_omnidirectional_camera[i].color.red == 255 and
                robot.colored_blob_omnidirectional_camera[i].color.green == 255 and
                robot.colored_blob_omnidirectional_camera[i].color.blue == 255) then
                    state = "choose"
                    object = " small_disc"
            elseif(robot.colored_blob_omnidirectional_camera[i].color.red == 160 and
                robot.colored_blob_omnidirectional_camera[i].color.green == 32 and
                robot.colored_blob_omnidirectional_camera[i].color.blue == 240) then
                    state = "choose"
                    object = "small_box"
            elseif(robot.colored_blob_omnidirectional_camera[i].color.red == 255 and
                robot.colored_blob_omnidirectional_camera[i].color.green == 140 and
                robot.colored_blob_omnidirectional_camera[i].color.blue == 0) then
                    state = "choose"
                    object = "large_box"
            end
        end
    end
end
--------------------------------------------------------------------------------
--------------------------------to charge()-------------------------------------
--------------------------------------------------------------------------------
--[[function to_charge()
    if robot.positioning.position.x < 0 then -- the location we must go

    elseif robot.positioning.position.x >= 0 then

    end

end--]]
--[[----------------------------------------------------------------------------
-----------------------------function charge()----------------------------------
--------------------------------------------------------------------------------
function to_charge()
    robot.wheels.set_velocity(0,0)
    bat_cur = bat_cur + 10
    if bat_cur >= (90/100)*bat_total then
        state = "search"
    end
end
--------------------------------------------------------------------------------
]]--
----------------------------function choose()-----------------------------------
function choose()
  if #robot.colored_blob_omnidirectional_camera == 0 then
      state = "search"
  else
      robot.wheels.set_velocity(0,0)
      closest = robot.colored_blob_omnidirectional_camera[1]
      dist = robot.colored_blob_omnidirectional_camera[1].distance
      ang =  robot.colored_blob_omnidirectional_camera[1].angle
      for i = 1, #robot.colored_blob_omnidirectional_camera do

          if (robot.colored_blob_omnidirectional_camera[i].color.red == 165 and
              robot.colored_blob_omnidirectional_camera[i].color.green == 42 and
              robot.colored_blob_omnidirectional_camera[i].color.blue == 42) or
              (robot.colored_blob_omnidirectional_camera[i].color.red == 255 and
               robot.colored_blob_omnidirectional_camera[i].color.green == 255 and
               robot.colored_blob_omnidirectional_camera[i].color.blue == 255) or
               (robot.colored_blob_omnidirectional_camera[i].color.red == 160 and
                robot.colored_blob_omnidirectional_camera[i].color.green == 32 and
                robot.colored_blob_omnidirectional_camera[i].color.blue == 240) or
                (robot.colored_blob_omnidirectional_camera[i].color.red == 255 and
                robot.colored_blob_omnidirectional_camera[i].color.green == 140 and
                robot.colored_blob_omnidirectional_camera[i].color.blue == 0)then
              closest = robot.colored_blob_omnidirectional_camera[i]
              dist = closest.distance
              ang = closest.angle

          end

      end
      if ang > 0.1 then
          robot.wheels.set_velocity(-1,1)
      elseif ang < -0.1 then
          robot.wheels.set_velocity(1,-1)
      elseif ang >= -0.1 and ang <= 0.1 then
          state = "approach"
      end
  end
end
---------------------------function approach()----------------------------------
function approach()
    if #robot.colored_blob_omnidirectional_camera > 0 then
        x = 0
        for i = 1, 24 do --some modification must be done here as we need not check
                         --all proximity sensors then ones located in front shall do
            if x < robot.proximity[i].value then
                x = robot.proximity[i].value
            end
        end
    -------trying to keep the orientation while approaching the obstacle------------
        dist = robot.colored_blob_omnidirectional_camera[1].distance
        ang =  robot.colored_blob_omnidirectional_camera[1].angle

        for i = 1, #robot.colored_blob_omnidirectional_camera do

            if dist > robot.colored_blob_omnidirectional_camera[i].distance and
                (robot.colored_blob_omnidirectional_camera[i].color.red == 255 or
                robot.colored_blob_omnidirectional_camera[i].color.blue == 255) then

                dist = robot.colored_blob_omnidirectional_camera[i].distance
                ang = robot.colored_blob_omnidirectional_camera[i].angle

            end
        end
        if ang > 0 then
            robot.wheels.set_velocity(5,6)
        end
        if ang < 0 then
            robot.wheels.set_velocity(6,5)
        end
        if ang == 0 then
            robot.wheels.set_velocity(5,5)
        end
    -------------trying to slow down when reaching near the obstacle----------------
        if x >= 0.5 then
            robot.wheels.set_velocity((1 - x) * 10, (1 - x) * 10)
        end
        if x >= 0.9 then
            robot.wheels.set_velocity(0,0)
            state = "decide"
        end
    else
        state = "search"
    end
end

----------------------------function decide()-----------------------------------
function decide()
    robot.wheels.set_velocity(10,-10)
    if decide_check == 0 then
      if object == "large_disc" then
        log("detected 'large_disc'")
      elseif object == "small_disc" then
        log("detected 'small_disc'")
      elseif object == "large_box" then
        log("detected 'large_box'")
      elseif object == "small_box" then
        log("detected 'small_box'")
      end
      decide_check = decide_check + 1
    end
end
