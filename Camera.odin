package main

import rl "vendor:raylib"

Camera :: struct {
    camera: rl.Camera2D,
}

init_camera :: proc() -> Camera {
    return Camera{
        camera = rl.Camera2D{
            offset = {f32(rl.GetScreenWidth()) / 2, f32(rl.GetScreenHeight()) / 2},
            target = {0, 0},
            rotation = 0,
            zoom = 1,
        },
    }
}

update_camera :: proc(cam: ^Camera, target: rl.Vector2) {
    cam.camera.target = target
}

begin_camera_mode :: proc(cam: ^Camera) {
    rl.BeginMode2D(cam.camera)
}

end_camera_mode :: proc() {
    rl.EndMode2D()
}