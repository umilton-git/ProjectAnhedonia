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

    // Normalize diagonal movement
    if movement.x != 0 && movement.y != 0 {
        movement = rl.Vector2Normalize(movement)
    }

    // Apply speed and delta time
    movement = rl.Vector2Scale(movement, speed * delta_time)

    // Calculate new position
    new_position := rl.Vector2Add(p.position, movement)

    // Calculate map boundaries
    screen_width := f32(rl.GetScreenWidth())
    screen_height := f32(rl.GetScreenHeight())
    map_x := (screen_width - game_map.size.x) / 2
    map_y := (screen_height - game_map.size.y) / 2

    // Get player dimensions
    player_width := f32(p.texture.width) / f32(p.num_frames) * 1.5
    player_height := f32(p.texture.height) * 1.5

    // Clamp the new position within the map boundaries
    new_position.x = clamp(new_position.x, map_x, map_x + game_map.size.x - player_width)
    new_position.y = clamp(new_position.y, map_y, map_y + game_map.size.y - player_height)

    // Update the player's position
    p.position = new_position
}

clamp :: proc(value, min, max: f32) -> f32 {
    if value < min do return min
    if value > max do return max
    return value
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