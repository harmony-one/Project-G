# Chain Force Game Design Document (GDD)

## 1. Game Overview

### 1.1 Concept

**Chain Force** is a groundbreaking 3D SHMUP (Shoot-em-up) bullet-hell style MOBA (Multiplayer Online Battle Arena) game that merges the adrenaline-pumping action of fast-paced space combat with the strategic depth of team play. Players will navigate through bullet-ridden battlegrounds, strategize with teammates, and engage in intense space warfare to dominate the arena.

                ![](https://lh7-us.googleusercontent.com/n-6WAUoEP6F6FYXY22VIKpW1XJP3YbSWa54g7NkoCWxZf-ytJqs2ceeqaMQyVtBABAKYeXUtIgOxPSIw3QFtgz8ZSQGOYm7WvqEI-vIOe4yRxPGMVVsYahR4W8en3-Rb6rr3jY0NkZ6alKVhgPxsP7A)

More Information:\
[https://en.wikipedia.org/wiki/Bullet\_hell\
https://en.wikipedia.org/wiki/Multiplayer\_online\_battle\_arena\
https://en.wikipedia.org/wiki/SHMUP](https://en.wikipedia.org/wiki/Bullet_hell)


### 1.2 Platform

The game is designed for desktop and mobile platforms, focusing on seamless cross-platform play, ensuring a wide-reaching player base.


### 1.3 Engine

The development will use Godot (4.2), leveraging its powerful and flexible toolset to create an immersive and dynamic gaming experience.\
More Information:

<https://docs.godotengine.org/en/stable/>


## 2. Gameplay Mechanics

![](https://lh7-us.googleusercontent.com/ZT3MC2BL9zVO_PUOuzR7gjbwHZGcymskfex_4TUY0f33ce-nF7wOV1krGWsdxrREg912GdZGxyXOYAfVRGMfdauzL78QLE4TNSFymbrofL3AKDnxRnQNFNXA1FXr8KQt9x-6beh-2Ijyyj8UbQk6oQE)


### 2.1 Rules

#### Standard Mode

- The game features three navigable lanes filled with obstacles such as space debris

- Teams are divided into Red and Blue, each starting on opposite sides of the map

- Defense cannons are placed throughout each lane to add strategic depth

- Enemy ships, controlled by AI, spawn from bases and move along the lanes to attack players and structures

- The objective is to destroy the opposing team

  - Destroy the cannons guarding each lane into the enemy base

  - Destroy the enemy base


#### Arcade Mode

- A single-player or co-op mode that focuses on classic arcade-style gameplay

- Players aim to achieve high scores recorded on a blockchain-based leaderboard


### 2.2 Level Features

- Fog of war to conceal enemy movements

- 2-5 lanes of the play area with varying layouts

- A player HUD displays vital information

- Random upgrades and power-ups

- Enemy players and AI-controlled ships

- Subtle in-game advertising through billboards dispersed through the lanes


### 2.3 Player

#### Movement

- Players can move in 360°, with variable speeds


#### Powerups

- Speed and firing rate boosts

- Temporary shields with two levels of duration


#### Weapons

- A variety of weapons

  - Smart mine - Homing mines targeting nearby enemies

  - Mine - Standard explosive mines

  - ‘Sploder (X seconds the projectile fragments)

  - Plasma cannons - High-energy weapons with splash damage

  - Vulcan cannons - Rapid-fire ballistic weapons

  - Kinetic weapons - Standard ballistic weapons

- Special weapons

  - EMP Blast - Disables enemy ships temporarily

  - Plasma chain (energy chain linked between two ships)

    - Requires same ship type


### 2.4 Races and Societies/Factions

- Details TBD.


### 2.5 Enemies

- AI-controlled ships with varying difficulty levels

- Boss enemies with unique tactics and abilities


### 2.6 Balancing

- Regular updates to balance gameplay based on analytics and player feedback


## 3. Multiplayer

- Online multiplayer supporting team-based combat

- Blockchain integration for authentication, ownership, and achievements


## 4. Account Security

- Utilizes Web3 authentication with ERC4337 account abstraction for enhanced security


## 5. User Experience

### Menus

- Main Menu

- Challenge Mode

- Lobby for multiplayer

- Options


### Gameplay Area

##### ![](https://lh7-us.googleusercontent.com/nAaYfwwYhN909POE00PhI0xv-VylCxsQ90or9GflV4NYuxgvFmEKit5CSi8my5IkvKD0xYulF0Kp8TGfM7kUe0awY1bhtI4jwFFdj0J6gU7JAs6SqoIc4WTLbEnPz8OdoUrbqgIHeHRzES7WIB2D_EI)

## 6. Art and Sound Design

- Details TBD


## 7. Technical Specifications

- Details TBD


## 8. Monetization Strategy

- In-app purchases for cosmetics and non-competitive upgrades

- NFT sales for unique ships and items, utilizing the Harmony protocol for transactions

- In-game billboard advertising

- Game can be accessed to any account that holds a ChainForce ship asset (ERC721)


## 9. Marketing and Community Engagement

- Marketing plan TBD


## 10. Development Roadmap

### Phases

1. Conceptualization

2. Pre-Production

3. Production

4. Testing

5. Launch


### Milestones

- Alpha and Beta releases leading to the official launch
