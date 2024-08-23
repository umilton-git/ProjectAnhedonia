package main
import rl "vendor:raylib"

main :: proc() {
    rl.InitWindow(800, 600, "Test")
    rl.SetTargetFPS(60)

    // Initialize the player
    player := init_player("TheBull.png", {300, 400})

    // Initialize the map
    game_map := init_map({600, 400}, rl.GREEN)


    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        draw_map(&game_map)

        // Update and draw the player
        move_player(&player, 400) // 400 pixels per second
        update_player_frame(&player)
        draw_player(&player)

        rl.EndDrawing()
    }

    rl.CloseWindow()
}