package main
import rl "vendor:raylib"

main :: proc() {
    rl.InitWindow(800, 600, "Test")
    rl.SetTargetFPS(60)

    // Initialize the map
    game_map := init_map({1000, 1000}, rl.Color{224, 217, 168, 255})

    // Initialize the player at the center of the map
    player := init_player("TheBull.png", {game_map.size.x/2, game_map.size.y/2})

    // Add some NonPlayables to the map
    add_np_to_map(&game_map, init_np({50, 50}, {200, 100}, rl.RED, true, InteractionType.DisplayText))
    add_np_to_map(&game_map, init_np({30, 30}, {500, 250}, rl.BLUE, true, InteractionType.None))

    // Initialize the camera
    camera := init_camera(game_map.size)


    for !rl.WindowShouldClose() {
        // Update
        move_player(&player, &game_map, 400) // 400 pixels per second
        update_player_frame(&player)
        update_camera(&camera, player.position)

        // Update camera to center on player
        camera_target := rl.Vector2{
            player.position.x + player.size.x/2,
            player.position.y + player.size.y/2,
        }
        update_camera(&camera, camera_target)

        // Draw
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        begin_camera_mode(&camera)
        {
            draw_map(&game_map)
            draw_player(&player)
        }
        end_camera_mode()

        // UI Elements Will Go Here

        rl.EndDrawing()
    }

    rl.CloseWindow()
}