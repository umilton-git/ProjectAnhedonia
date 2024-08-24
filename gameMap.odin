package main
import rl "vendor:raylib"

GameMap :: struct {
    size: rl.Vector2,
    color: rl.Color,
    objects: [dynamic]Object,
}

init_map :: proc(dimensions: rl.Vector2, col: rl.Color) -> GameMap {
    return GameMap{
        size = dimensions,
        color = col,
        objects = make([dynamic]Object),
    }
}

add_object_to_map :: proc(m: ^GameMap, obj: Object) {
    append(&m.objects, obj)
}

draw_map :: proc(m: ^GameMap) {
    // Draw the map as a rectangle with the given size and color
    rl.DrawRectangle(0, 0, i32(m.size.x), i32(m.size.y), m.color)

    // Draw all objects on the map
    for &obj in m.objects {
        draw_object(&obj)
    }
}