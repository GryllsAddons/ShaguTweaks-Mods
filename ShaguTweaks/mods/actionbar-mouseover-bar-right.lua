local module = ShaguTweaks:register({
    title = "Mouseover Right",
    description = "Hide the Right ActionBar and show on mouseover.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Action Bar",
    enabled = nil,
})

module.enable = function(self)
    ShaguTweaks.MouseoverRight = true
    local _G = _G or getfenv(0)

    local timer = CreateFrame("Frame", nil, UIParent)
    local mouseOverBar
    local mouseOverButton
        
    local function hide(bar)
        bar:Hide()
    end
    
    local function show(bar)
        bar:Show()
    end
    
    local function mouseover(bar)
        local function setTimer()
            timer.time = GetTime() + 2
            timer:SetScript("OnUpdate", function()
                if GetTime() >= timer.time then
                    hide(bar)
                    timer:SetScript("OnUpdate", nil)
                end
            end)
        end
    
        local tooltipVisible = GameTooltip:IsVisible()
        if (not tooltipVisible) and (mouseOverButton or mouseOverBar) then
            timer:SetScript("OnUpdate", nil)
            show(bar)
        elseif (not tooltipVisible) and (not mouseOverBar) and (not mouseOverButton) then
            setTimer()
        end
    end
    
    local function barEnter(frame, bar)
        frame:SetScript("OnEnter", function()
            mouseOverBar = true
            mouseover(bar)
        end)
    end
    
    local function barLeave(frame, bar)
        frame:SetScript("OnLeave", function()
            mouseOverBar = false     
            mouseover(bar)
        end)
    end
    
    local function buttonEnter(frame, bar)
        frame:SetScript("OnEnter", function()
            mouseOverButton = true
            frame:EnableMouse(false)
            mouseover(bar)        
        end)
    end
    
    local function buttonLeave(frame, bar)
        frame:SetScript("OnLeave", function()
            mouseOverButton = false
            frame:EnableMouse(true)
            mouseover(bar)
        end)
    end
    
    local function mouseoverButton(button, bar)
        local frame = CreateFrame("Frame", nil, UIParent)    
        frame:SetAllPoints(button)
        frame:EnableMouse(true)
        frame:SetFrameStrata("DIALOG")    
        buttonEnter(frame, bar)
        buttonLeave(frame, bar)
    end
    
    local function mouseoverBar(bar)
        local frame = CreateFrame("Frame", nil, UIParent)
        frame:SetAllPoints(bar)
        frame:EnableMouse(true)
        barEnter(frame, bar) 
        barLeave(frame, bar)
    end

    local function movebags()
        if ShaguTweaks.MouseoverRight2 then return end
        if MultiBarLeft:IsVisible() then
            ContainerFrame1:ClearAllPoints()
            ContainerFrame1:SetPoint("RIGHT", MultiBarLeft, "LEFT", -5)
        elseif MultiBarRight:IsVisible() then
            ContainerFrame1:ClearAllPoints()
            ContainerFrame1:SetPoint("RIGHT", MultiBarRight, "LEFT", -5)
        end
    end
    
    local function setup(bar)
        if not bar:IsVisible() then return end            
        for i = 1, 12 do
            for _, button in pairs(
                    {
                    _G[bar:GetName()..'Button'..i],
                }
            ) do
                mouseoverButton(button, bar)
            end
        end
        mouseoverBar(bar)
        hide(bar)        
    end
    
    
    local events = CreateFrame("Frame", nil, UIParent)
    events:RegisterEvent("PLAYER_ENTERING_WORLD")
    events:SetScript("OnEvent", function()
        movebags()
        setup(MultiBarRight)        
    end)    
end
