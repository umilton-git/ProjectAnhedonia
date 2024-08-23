package main
import "vendor:raylib"

main :: proc() {
    raylib.InitWindow(800, 600, "Test")
    raylib.SetTargetFPS(60)

    // Initialize the player
    player := init_player("TheBull.png", {300, 400})

    for !raylib.WindowShouldClose() {
        raylib.BeginDrawing()
        raylib.ClearBackground(raylib.RAYWHITE)

        // Update and draw the player
        move_player(&player, 400) // 400 pixels per second
        update_player_frame(&player)
        draw_player(&player)

        raylib.EndDrawing()
    }

    raylib.CloseWindow()
}