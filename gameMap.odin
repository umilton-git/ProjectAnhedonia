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
    // Calculate the position to center the map
    screen_width := f32(rl.GetScreenWidth())
    screen_height := f32(rl.GetScreenHeight())
    map_x := (screen_width - m.size.x) / 2
    map_y := (screen_height - m.size.y) / 2

    // Draw the map as a rectangle with the given size and color
    rl.DrawRectangle(
        i32(map_x),
        i32(map_y),
        i32(m.size.x),
        i32(m.size.y),
        m.color
    )
}