package main
import rl "vendor:raylib"

GameMap :: struct {
    size: rl.Vector2,
    color: rl.Color,
    nps: [dynamic]NP,
}

init_map :: proc(dimensions: rl.Vector2, col: rl.Color) -> GameMap {
    return GameMap{
        size = dimensions,
        color = col,
        nps = make([dynamic]NP),
    }
}

add_np_to_map :: proc(m: ^GameMap, np: NP) {
    append(&m.nps, np)
}

draw_map :: proc(m: ^GameMap) {
    // Draw the map as a rectangle with the given size and color
    rl.DrawRectangle(0, 0, i32(m.size.x), i32(m.size.y), m.color)

    // Draw all objects on the map
    for &np in m.nps {
        draw_nonplayable(&np)
    }
}