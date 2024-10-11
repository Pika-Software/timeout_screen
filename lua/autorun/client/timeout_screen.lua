local _G = _G
local min = _G.math.min
local Add = _G.hook.Add
local GetTimeoutInfo = _G.GetTimeoutInfo

local addonName = "Pika Software - Timeout Screen"
local isInTimeout, alpha = false, 0

do

    local seconds = 0

    Add( "Think", addonName, function()
        isInTimeout, seconds = GetTimeoutInfo()
        if isInTimeout then
            if seconds > 3 then
                alpha = 255
            else
                alpha = min( 1, seconds / 3 ) * 255
            end
        elseif alpha ~= 0 then
            alpha = 0
        end
    end )

end

local screenWidth, screenHeight = _G.ScrW(), _G.ScrH()
local vmin = min( screenWidth, screenHeight )

Add( "OnScreenSizeChanged", addonName, function( _, __, width, height )
    screenWidth, screenHeight = width, height
    vmin = min( width, height )
end )

local SetDrawColor, SetMaterial, DrawRect, DrawTexturedRect
do
    local surface = _G.surface
    SetDrawColor, SetMaterial, DrawRect, DrawTexturedRect = surface.SetDrawColor, surface.SetMaterial, surface.DrawRect, surface.DrawTexturedRect
end

local material = _G.Material( "pikasoft/timeout_screen/cats" )

Add( "PostDrawHUD", addonName, function()
    if not isInTimeout then
        return nil
    end

    SetDrawColor( 0, 0, 0, alpha )
    DrawRect( 0, 0, screenWidth, screenHeight )

    if alpha == 255 then
        SetDrawColor( 255, 255, 255, alpha )
        SetMaterial( material )

        DrawTexturedRect( ( screenWidth - ( vmin * 0.5 ) ) * 0.5, ( screenHeight - ( vmin * 0.4 ) ) * 0.5, vmin * 0.5, vmin * 0.4 )
    end

    return nil
end )

Add( "CreateMove", addonName, function( cmd )
    if alpha == 255 then
        cmd:ClearMovement()
        cmd:ClearButtons()
        return true
    end
end )
