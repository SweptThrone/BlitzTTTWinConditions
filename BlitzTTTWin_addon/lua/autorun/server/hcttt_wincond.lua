hook.Add( "TTTCheckForWin", "BlitzTTT.WinConditions", function()

    -- before anything else, check time limit
    if CurTime() > GetGlobalFloat( "ttt_round_end", 0 ) then
        return WIN_TIMELIMIT
    end

    local traitorsWin = true
    local traitorAlive = false

    for k, v in pairs( util.GetAlivePlayers() ) do
        -- if there is any non-traitor alive, the traitors cannot win
        if v:GetRole() == ROLE_INNOCENT or v:GetRole() == ROLE_DETECTIVE then
            traitorsWin = false
        end

        -- if there is a traitor alive, we don't have to check bodies
        if v:GetRole() == ROLE_TRAITOR then
            traitorAlive = true
        end
    end

    local traitorsLeft = CountTraitors()

    -- if there are no traitors alive, we have to check if the traitor bodies are found
    if not traitorAlive then
        for k, v in pairs( ents.FindByClass( "prop_ragdoll" ) ) do
            if v.player_ragdoll and v.was_role == ROLE_TRAITOR and CORPSE.GetFound( v, false ) then
                traitorsLeft = traitorsLeft - 1
            end
        end
    end

    if traitorsWin then
        return WIN_TRAITOR
    end

    if traitorsLeft == 0 then
        return WIN_INNOCENT
    end

    return WIN_NONE
end )