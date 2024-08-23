package main
import "vendor:raylib"

Player :: struct {
    position: raylib.Vector2,
    texture:  raylib.Texture2D,
    num_frames: int,
    current_frame: int,
    frame_timer: f32,
    frame_length: f32,
}

init_player :: proc(texture_path: cstring, start_pos: raylib.Vector2) -> Player {
    return Player{
        position = start_pos,
        texture = raylib.LoadTexture(texture_path),
        num_frames = 1,
        current_frame = 0,
        frame_timer = 0,
        frame_length = 0.1,
    }
}

move_player :: proc(p: ^Player, speed: f32) {
    if raylib.IsKeyDown(.LEFT) {
        p.position.x -= speed * raylib.GetFrameTime()
    }
    if raylib.IsKeyDown(.RIGHT) {
        p.position.x += speed * raylib.GetFrameTime()
    }
    if raylib.IsKeyDown(.DOWN) {
        p.position.y += speed * raylib.GetFrameTime()
    }
    if raylib.IsKeyDown(.UP) {
        p.position.y -= speed * raylib.GetFrameTime()
    }
}

update_player_frame :: proc(p: ^Player) {
    p.frame_timer += raylib.GetFrameTime()

    if p.frame_timer > p.frame_length {
        p.current_frame += 1
        p.frame_timer = 0
        if p.current_frame == p.num_frames {
            p.current_frame = 0
        }
    }
}

draw_player :: proc(p: ^Player) {
    frame_width := f32(p.texture.width) / f32(p.num_frames)
    frame_height := f32(p.texture.height)

    source_rect := raylib.Rectangle{
        x = f32(p.current_frame) * frame_width,
        y = 0,
        width = frame_width,
        height = frame_height,
    }

    dest_rect := raylib.Rectangle{
        x = p.position.x,
        y = p.position.y,
        width = frame_width * 1.5,
        height = frame_height * 1.5,
    }

    raylib.DrawTexturePro(p.texture, source_rect, dest_rect, raylib.Vector2{0, 0}, 0, raylib.WHITE)
}