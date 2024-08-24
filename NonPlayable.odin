package main
import rl "vendor:raylib"

InteractionType :: enum {
    DisplayText,
    TriggerEffect,
    Collectible,
}

InteractionData :: struct {
    text: string,
    effect_id: int,
    collectible_id: string,
}

MovementType :: enum {
    Random,
    BackNForth,
}

NP :: struct {
    size: rl.Vector2,
    mapLocation: rl.Vector2,
    color: rl.Color,
    interactable: bool,
    interaction_type: Maybe(InteractionType),
    interaction_data: Maybe(InteractionData),
    movementRange: Maybe(rl.Vector2),
    movementType: Maybe(MovementType),
    movementSpeed: Maybe(int),
}

init_np :: proc(dimensions: rl.Vector2, loc: rl.Vector2, col: rl.Color, interact: bool, inter_type: Maybe(InteractionType) = nil, inter_data: Maybe(InteractionData) = nil, moveRange: Maybe(rl.Vector2) = nil, moveType: Maybe(MovementType) = nil, moveSpd: Maybe(int) = nil) -> NP {
    return NP{
        size = dimensions,
        mapLocation = loc,
        color = col,
        interactable = interact,
        interaction_type = inter_type,
        interaction_data = inter_data,
        movementRange = moveRange,
        movementType = moveType,
        movementSpeed = moveSpd,
    }
}

draw_nonplayable :: proc(np: ^NP) {
    rl.DrawRectangleV(np.mapLocation, np.size, np.color)
    
    if np.interactable {
        // Draw an indicator for interactable objects
        indicator_size := rl.Vector2{10, 10}
        indicator_pos := rl.Vector2{
            np.mapLocation.x + np.size.x / 2 - indicator_size.x / 2,
            np.mapLocation.y - indicator_size.y - 5,
        }
        rl.DrawRectangleV(indicator_pos, indicator_size, rl.YELLOW)
    }
}