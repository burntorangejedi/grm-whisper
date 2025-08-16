local GRMWhisper = LibStub("AceAddon-3.0"):NewAddon("GRMWhisper", "AceConsole-3.0")

function GRMWhisper:OnInitialize()
    self:RegisterChatCommand("grmw", "OpenUI")
end

function GRMWhisper:OpenUI()
    if not IsInGuild() then
        self:Print("⚠️ You must be in a guild to use this tool.")
        return
    end

    local frame = LibStub("AceGUI-3.0"):Create("Frame")
    frame:SetTitle("GRM Whisper Tool")
    frame:SetStatusText("Whisper all members at a specific rank")
    frame:SetLayout("Flow")
    frame:SetWidth(450)
    frame:SetHeight(400)

    -- Dropdown
    local dropdown = LibStub("AceGUI-3.0"):Create("Dropdown")
    dropdown:SetLabel("Target Rank")
    dropdown:SetWidth(400)

    local rankNames = {}
    for i = 0, GuildControlGetNumRanks() - 1 do
        local name = GuildControlGetRankName(i + 1) or ("Rank " .. i)
        rankNames[i + 1] = name
    end
    dropdown:SetList(rankNames)
    dropdown:SetText("Select rank...")
    frame:AddChild(dropdown)

    -- Multiline Edit Box
    local editBox = LibStub("AceGUI-3.0"):Create("MultiLineEditBox")
    editBox:SetLabel("Message")
    editBox:SetNumLines(8)
    editBox:SetFullWidth(true)
    editBox:SetText("")
    frame:AddChild(editBox)

    -- Send Button
    local sendButton = LibStub("AceGUI-3.0"):Create("Button")
    sendButton:SetText("Send Whispers")
    sendButton:SetWidth(200)
    sendButton:SetCallback("OnClick", function()
        local selectedIndex = dropdown:GetValue()
        local message = editBox:GetText()

        if not selectedIndex then
            self:Print("⚠️ Please select a rank.")
            return
        end
        if not message or message == "" then
            self:Print("⚠️ Please enter a message.")
            return
        end

        local sent = {}
        local failed = {}

        for i = 1, GetNumGuildMembers() do
            local name, _, rank = GetGuildRosterInfo(i)
            if rank == selectedIndex - 1 then
                local success = SendChatMessage(message, "WHISPER", nil, name)
                if success then
                    table.insert(sent, name)
                else
                    table.insert(failed, name)
                end
            end
        end

        self:Print("✅ Sent to: " .. table.concat(sent, ", "))
        if #failed > 0 then
            self:Print("❌ Failed to send to: " .. table.concat(failed, ", "))
        end
    end)
    frame:AddChild(sendButton)
end