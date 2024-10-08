package main

import rl "vendor:raylib"
import "core:strings"
import "core:fmt"

DialogueBox :: struct {
    position: rl.Vector2,
    size: rl.Vector2,
    messages: []string,
    current_message: int,
    font: rl.Font,
    font_size: f32,
    text_color: rl.Color,
    background_color: rl.Color,
    current_char: int,
    char_reveal_speed: f32,
    time_since_last_char: f32,
    is_active: bool,
}

global_dialogue_box: DialogueBox

init_dialogue_system :: proc(pos, size: rl.Vector2, font: rl.Font, font_size: f32) {
    global_dialogue_box = DialogueBox{
        position = pos,
        size = size,
        font = font,
        font_size = font_size,
        text_color = rl.BLACK,
        background_color = rl.LIGHTGRAY,
        char_reveal_speed = 0.05,
        is_active = false,
    }
}

display_dialogue :: proc(messages: []string) {
    global_dialogue_box.messages = messages
    global_dialogue_box.current_message = 0
    global_dialogue_box.current_char = 0
    global_dialogue_box.time_since_last_char = 0
    global_dialogue_box.is_active = true
}

update_dialogue :: proc() -> bool {
    if !global_dialogue_box.is_active do return false

    current_text := global_dialogue_box.messages[global_dialogue_box.current_message]

    global_dialogue_box.time_since_last_char += rl.GetFrameTime()
    if global_dialogue_box.time_since_last_char >= global_dialogue_box.char_reveal_speed && 
       global_dialogue_box.current_char < len(current_text) {
        global_dialogue_box.current_char += 1
        global_dialogue_box.time_since_last_char = 0
    }

    if rl.IsKeyPressed(.Z) {
        if global_dialogue_box.current_char < len(current_text) {
            global_dialogue_box.current_char = len(current_text)  // Reveal all text
        } else {
            global_dialogue_box.current_message += 1
            if global_dialogue_box.current_message >= len(global_dialogue_box.messages) {
                global_dialogue_box.is_active = false  // Close the dialogue box
                return false  // Dialogue ended
            } else {
                global_dialogue_box.current_char = 0  // Reset for next message
            }
        }
    }

    return true  // Dialogue still active
}

draw_dialogue :: proc() {
    if !global_dialogue_box.is_active do return

    rl.DrawRectangleV(global_dialogue_box.position, global_dialogue_box.size, global_dialogue_box.background_color)
    current_text := global_dialogue_box.messages[global_dialogue_box.current_message]
    visible_text := current_text[:global_dialogue_box.current_char]
    
    c_text := strings.clone_to_cstring(visible_text)
    defer delete_cstring(c_text)

    rl.DrawTextEx(global_dialogue_box.font, c_text, 
                  {global_dialogue_box.position.x + 10, global_dialogue_box.position.y + 10}, 
                  global_dialogue_box.font_size, 2, global_dialogue_box.text_color)
}