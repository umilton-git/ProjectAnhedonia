package main
import rl "vendor:raylib"

Player :: struct {
    position: rl.Vector2,
    texture:  rl.Texture2D,
    num_frames: int,
    current_frame: int,
    frame_timer: f32,
    frame_length: f32,
    size: rl.Vector2,  // Add this field to store the player's size
}

init_player :: proc(texture_path: cstring, start_pos: rl.Vector2) -> Player {
    texture := rl.LoadTexture(texture_path)
    frame_width := f32(texture.width) / f32(1)  // Assuming 1 frame for now
    frame_height := f32(texture.height)
    return Player{
        position = start_pos,
        texture = texture,
        num_frames = 1,
        current_frame = 0,
        frame_timer = 0,
        frame_length = 0.1,
        size = {frame_width * 1.5, frame_height * 1.5},  // Store the scaled size
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

move_player :: proc(p: ^Player, game_map: ^GameMap, speed: f32) {
    delta_time := rl.GetFrameTime()
    movement := rl.Vector2{}

    if rl.IsKeyDown(.LEFT) {
        movement.x -= 1
    }
    if rl.IsKeyDown(.RIGHT) {
        movement.x += 1
    }
    if rl.IsKeyDown(.DOWN) {
        movement.y += 1
    }
    if rl.IsKeyDown(.UP) {
        movement.y -= 1
    }

    if movement.x != 0 && movement.y != 0 {
        movement = rl.Vector2Normalize(movement)
    }

    movement = rl.Vector2Scale(movement, speed * delta_time)

    new_position := rl.Vector2Add(p.position, movement)

    // Clamp the new position within the map boundaries
    new_position.x = clamp(new_position.x, 0, game_map.size.x - p.size.x)
    new_position.y = clamp(new_position.y, 0, game_map.size.y - p.size.y)

    p.position = new_position
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
        width = p.size.x,
        height = p.size.y,
    }

    rl.DrawTexturePro(p.texture, source_rect, dest_rect, rl.Vector2{0, 0}, 0, rl.WHITE)
}