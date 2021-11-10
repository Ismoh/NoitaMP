function ConfigGun_Init( value )
    value.actions_per_round = 1
    value.shuffle_deck_when_empty = false
    value.reload_time = 40
    value.deck_capacity = 2
end

function ConfigGun_PassToGame( value )
    RegisterGun(
        value.actions_per_round, 
        value.shuffle_deck_when_empty, 
        value.reload_time, 
        value.deck_capacity
  )
end
function ConfigGun_ReadToLua( actions_per_round, shuffle_deck_when_empty, reload_time, deck_capacity )
    __globaldata = {}
    __globaldata.actions_per_round = actions_per_round
    __globaldata.shuffle_deck_when_empty = shuffle_deck_when_empty
    __globaldata.reload_time = reload_time
    __globaldata.deck_capacity = deck_capacity
end
function ConfigGun_Copy( source, dest )
    dest.actions_per_round = source.actions_per_round
    dest.shuffle_deck_when_empty = source.shuffle_deck_when_empty
    dest.reload_time = source.reload_time
    dest.deck_capacity = source.deck_capacity
end
