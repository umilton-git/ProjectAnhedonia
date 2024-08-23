package main
import rl "vendor:raylib"

Player :: struct {
    position: rl.Vector2,
    texture:  rl.Texture2D,
    num_frames: int,
    current_frame: int,
    frame_timer: f32,
    frame_length: f32,
}

init_player :: proc(texture_path: cstring, start_pos: rl.Vector2) -> Player {
    return Player{
        position = start_pos,
        texture = rl.LoadTexture(texture_path),
        num_frames = 1,
        current_frame = 0,
        frame_timer = 0,
        frame_length = 0.1,
    }
}

move_player :: proc(p: ^Player, speed: f32) {
    if rl.IsKeyDown(.LEFT) {
        p.position.x -= speed * rl.GetFrameTime()
    }
    if rl.IsKeyDown(.RIGHT) {
        p.position.x += speed * rl.GetFrameTime()
    }
    if rl.IsKeyDown(.DOWN) {
        p.position.y += speed * rl.GetFrameTime()
    }
    if rl.IsKeyDown(.UP) {
        p.position.y -= speed * rl.GetFrameTime()
    }
}

update_player_frame :: proc(p: ^Player) {
    p.frame_timer += rl.GetFrameTime()

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

    source_rect := rl.Rectangle{
        x = f32(p.current_frame) * frame_width,
        y = 0,
        width = frame_width,
        height = frame_height,
    }

    dest_rect := rl.Rectangle{
        x = p.position.x,
        y = p.position.y,
        width = frame_width * 1.5,
        height = frame_height * 1.5,
    }

    rl.DrawTexturePro(p.texture, source_rect, dest_rect, rl.Vector2{0, 0}, 0, rl.WHITE)
}