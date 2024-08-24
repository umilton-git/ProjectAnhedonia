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

    // Check left movement
    if rl.IsKeyDown(.LEFT) && !check_collision(rl.Vector2{p.position.x - speed * delta_time, p.position.y}, p.size, game_map) {
        movement.x -= 1
    }
    // Check right movement
    if rl.IsKeyDown(.RIGHT) && !check_collision(rl.Vector2{p.position.x + speed * delta_time, p.position.y}, p.size, game_map) {
        movement.x += 1
    }
    // Check upward movement
    if rl.IsKeyDown(.UP) && !check_collision(rl.Vector2{p.position.x, p.position.y - speed * delta_time}, p.size, game_map) {
        movement.y -= 1
    }
    // Check downward movement
    if rl.IsKeyDown(.DOWN) && !check_collision(rl.Vector2{p.position.x, p.position.y + speed * delta_time}, p.size, game_map) {
        movement.y += 1
    }

    // Normalize diagonal movement
    if movement.x != 0 && movement.y != 0 {
        movement = rl.Vector2Normalize(movement)
    }

    // Apply movement
    movement = rl.Vector2Scale(movement, speed * delta_time)
    p.position = rl.Vector2Add(p.position, movement)

    // Clamp the position within the map boundaries
    p.position.x = clamp(p.position.x, 0, game_map.size.x - p.size.x)
    p.position.y = clamp(p.position.y, 0, game_map.size.y - p.size.y)
}

check_collision :: proc(player_pos, player_size: rl.Vector2, game_map: ^GameMap) -> bool {
    player_rect := rl.Rectangle{
        x = player_pos.x,
        y = player_pos.y,
        width = player_size.x,
        height = player_size.y,
    }
    
    for &obj in game_map.objects {
        obj_rect := rl.Rectangle{
            x = obj.mapLocation.x,
            y = obj.mapLocation.y,
            width = obj.size.x,
            height = obj.size.y,
        }
        
        if rl.CheckCollisionRecs(player_rect, obj_rect) {
            return true  // Collision detected
        }
    }
    
    return false  // No collision
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