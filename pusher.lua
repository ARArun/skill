bat_total = 10000
bat_cur = 10000

function init()

end

function step()
    if (bat_cur/bat_total) > 0.25 then
        robot.leds.set_all_colors(255,0,255)
    else
        robot.leds.set_all_colors(255,0,0)
    end
end


function reset()

end

function destroy()

end
