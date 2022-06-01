gsquads.Squads.Config = gsquads.Squads.Config or {
    squad_Names = {
        'Alpha',
        'Beta',
        'Gamma',
        'Delta',
        'Epsilon',
        'Zeta',
        'Eta',
        'Theta',
        'Iota',
        'Kappa',
    },

    squad_Maxsize = 4,
    squad_Maxnum = 10,
    EnableHUD = true,
}

function gsquads.Squads.Config.CustomCanCreate( ply )

    -- return false to stop player from creating. can by default
    return true 
end

function gsquads.Squads.Config.CustomCanJoin( squad, ply )

    -- return false to stop player from joining. can by default
    return true 
end