package main
import rl "vendor:raylib"

GameMap :: struct {
    size: rl.Vector2,
    color: rl.Color,
}

init_map :: proc(dimensions: rl.Vector2, col: rl.Color) -> GameMap {
    return GameMap{
        size = dimensions,
        color = col,
    }
}

draw_map :: proc(m: ^GameMap) {
    // Draw the map as a rectangle with the given size and color
    rl.DrawRectangle(0, 0, i32(m.size.x), i32(m.size.y), m.color)
}