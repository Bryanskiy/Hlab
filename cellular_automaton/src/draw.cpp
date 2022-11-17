#include <SFML/Graphics.hpp>
#include <iostream>
#include <limits.h>
#include <stdlib.h>
#include "draw.h"

sf::RenderWindow window;
sf::Event event;

uint32_t const colors[] = { 0x000000FF,
                            0xFFFFFFFF,
                            0x800000FF,
                            0xFF0000FF,
                            0xE9967AFF,
                            0xFF8C00FF,
                            0xFFFF00FF,
                            0xADFF2FFF,
                            0x98FB98FF,
                            0x20B2AAFF,
                            0x7FFFD4FF,
                            0x1E90FFFF,
                            0x8A2BE2FF,
                            0x6A5ACDFF,
                            0xDDA0DDFF,
                            0xFF69B4FF};

static sf::Color match_color(STATE state) {
    return sf::Color {colors[state]};
}

extern "C" {
    int dr_rand() {
        return rand();
    }

    void dr_init_window(unsigned width, unsigned height) {
        window.create(sf::VideoMode(width, height), "Game of Life");
    }

    void dr_put_pixel(int x, int y, STATE state) {
        sf::Color color = match_color(state);
        sf::Vertex point({static_cast<float>(x), static_cast<float>(y)}, color);
        window.draw(&point, 1, sf::Points);
    }

    void dr_flush() {
        while (window.pollEvent(event)) {
            if (event.type == sf::Event::Closed)
                window.close();
        }
        window.display();
    }
}