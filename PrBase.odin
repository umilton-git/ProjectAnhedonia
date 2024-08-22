package main

import "vendor:raylib"

main :: proc() {
    raylib.InitWindow(800, 600, "Test")
    raylib.SetTargetFPS(60)

    player_pos := raylib.Vector2 {400, 300}
    player_run_texture := raylib.LoadTexture("Big_Dude_Sheet.png")
    player_run_num_frames := 4
    player_run_frame_timer: f32
    player_run_current_frame: int
    player_run_frame_length := f32(0.1)

    for !raylib.WindowShouldClose() 
    {
        raylib.BeginDrawing()
        raylib.ClearBackground(raylib.RAYWHITE)
        if raylib.IsKeyDown(.LEFT)
        {
            player_pos.x -= 400 * raylib.GetFrameTime() // 400 pixels per seconds
        }
        if raylib.IsKeyDown(.RIGHT) 
        {
            player_pos.x += 400 * raylib.GetFrameTime() // 400 pixels per seconds
        }
        if raylib.IsKeyDown(.DOWN) 
        {
            player_pos.y += 400 * raylib.GetFrameTime() // 400 pixels per seconds
        }
        if raylib.IsKeyDown(.UP) 
        {
            player_pos.y -= 400 * raylib.GetFrameTime() // 400 pixels per seconds
        }

        player_run_width := f32(player_run_texture.width)
        player_run_height := f32(player_run_texture.height)

        player_run_frame_timer += raylib.GetFrameTime()

        if player_run_frame_timer > player_run_frame_length {
            player_run_current_frame += 1
            player_run_frame_timer = 0
            if player_run_current_frame == player_run_num_frames {
                player_run_current_frame = 0
            }
        }

        draw_player_source := raylib.Rectangle{
            x = f32(player_run_current_frame) * player_run_width / f32(player_run_num_frames),
            y = 0,
            width = player_run_width / f32(player_run_num_frames),
            height = player_run_height
        }
        raylib.DrawTextureRec(player_run_texture, draw_player_source, player_pos, raylib.WHITE)
        raylib.EndDrawing()
    }

    raylib.CloseWindow()
}