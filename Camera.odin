package main
import rl "vendor:raylib"

Camera :: struct {
    camera: rl.Camera2D,
    map_size: rl.Vector2,
    boundary_offset: f32,
}

init_camera :: proc(map_size: rl.Vector2, boundary_offset: f32 = 100) -> Camera {
    return Camera{
        camera = rl.Camera2D{
            offset = {f32(rl.GetScreenWidth()) / 2, f32(rl.GetScreenHeight()) / 2},
            target = {0, 0},
            rotation = 0,
            zoom = 1,
        },
        map_size = map_size,
        boundary_offset = boundary_offset,
    }
}

update_camera :: proc(cam: ^Camera, target: rl.Vector2) {
    screen_width := f32(rl.GetScreenWidth())
    screen_height := f32(rl.GetScreenHeight())

    // Calculate the maximum allowed camera position
    max_x := cam.map_size.x - screen_width/2 + cam.boundary_offset
    max_y := cam.map_size.y - screen_height/2 + cam.boundary_offset

    // Calculate the minimum allowed camera position
    min_x := screen_width/2 - cam.boundary_offset
    min_y := screen_height/2 - cam.boundary_offset

    // Clamp the camera target within the allowed range
    cam.camera.target.x = clamp(target.x, min_x, max_x)
    cam.camera.target.y = clamp(target.y, min_y, max_y)
}

begin_camera_mode :: proc(cam: ^Camera) {
    rl.BeginMode2D(cam.camera)
}

end_camera_mode :: proc() {
    rl.EndMode2D()
}

clamp :: proc(value, min, max: f32) -> f32 {
    if value < min do return min
    if value > max do return max
    return value
}