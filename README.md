# Asteroid

A clone of the classic Asteroids arcade game built with [Processing](https://processing.org/). This was a personal experiment to learn Processing. Not a production project, but a fully playable game with some polish.

## Features

Player ship with thrust physics based on F=ma movement, asteroid field with size based splitting, enemy UFOs in two difficulty modes, particle explosion system, procedural star field, sound effects, high score table with persistent JSON storage and stage progression with increasing difficulty.

## How to run

Download and install [Processing](https://processing.org/download).

Open Processing, go to Sketch, then Import Library, then Manage Libraries. Search for Minim and install it. It is required for audio.

Open asteroids.pde in Processing. It will load all the other .pde files automatically. Press the Run button.

## Controls

Up arrow for thrust, left and right arrows to rotate, space to shoot.

## Code notes

The code reflects the experimental nature of the project. It works and it is reasonably structured with managers for each subsystem, a base Entity class with physics and a state machine for game flow. It has the typical issues of a solo Processing sketch though: heavy global state, some magic numbers and collision detection scattered across classes. There is also a known input edge case where keys can get stuck in an invalid state.

## Built with

Processing 4 and Minim for audio.
