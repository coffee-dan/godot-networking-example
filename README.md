# Godot Networking Example

Based on [Multiplayer Arena Shooter by curtjs](https://www.youtube.com/watch?v=CS5qU7eOwb8&list=PLPYmLuhIwZO-v6rNON9hYKNJMXhfXwYtQ)

Using
- Godot 4.4
- Compatibility rendering
- netfox.noray for P2P setup

## Overview

Goal of this example is to create two player characters where one is controlled locally and the other is controlled via a networked player connection. This should be accomplished using the High-Level Networking API within Godot so that we are not tied down to a particular network protocol.

However, since the goal is to use WebRTC networking in a browser consider setting things up to be highly compatible with that:
- Godot 4.3+ because this introduces an web export template that utilizes single-thread which is more widely accepted by browsers due to a SharedArrayBuffer exploit in the multi-threaded approach used in earlier versions.
- GodotScript Only

- https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html
- https://github.com/godotengine/godot-demo-projects
- https://github.com/godotengine/godot-demo-projects/tree/master/networking/multiplayer_bomber

Use of netfox.noray based on multiplayer guide:
- https://www.youtube.com/watch?v=g-k_cM7aFgo&list=PLPYmLuhIwZO-v6rNON9hYKNJMXhfXwYtQ&index=4

## Current Progress

- Working multiplayer arena shooter over Noray example server

![recording](2025-04-19_godot-networking-example-progress-optimized.gif)
