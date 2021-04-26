extends Node

const SPRITE_UNIT: int = 16;
const MAX_UNITS_PER_JUMP: int = 6;
const MIN_UNITS_PER_JUMP: int = 1;
const GRAVITY = SPRITE_UNIT * 7;

const LEVEL_HEIGHT_GROWTH: int = 64;
const MIN_POINTS_TO_SHOW_THORNS: int = 200;

const PLAYER_SPEED: int = SPRITE_UNIT * 10;
const PLAYER_MAX_JUMP_HEIGHT: float = SPRITE_UNIT * (MAX_UNITS_PER_JUMP + 0.25);
const PLAYER_MIN_JUMP_HEIGHT: float = SPRITE_UNIT * (MIN_UNITS_PER_JUMP + 0.25);
const PLAYER_JUMP_DURATION:float = 0.45;
const PLAYER_COYOTE_TIMER_DURATION: float = 0.2;

const PLATFORM_LEFT_X: int = 8;
const PLATFORM_RIGHT_X: int = 108;
const PLATFORM_DISTANCE_TO_NEW: int = LEVEL_HEIGHT_GROWTH + (LEVEL_HEIGHT_GROWTH * 4);

const MOVING_PLATFORM_X_DISTANCE: float = SPRITE_UNIT * 6.25;
const MOVING_PLATFORM_Y_DISTANCE: float = SPRITE_UNIT * 4.0;
const MOVING_PLATFORM_IDDLE_DURATION: float = 1.0;
const MOVING_PLATFORM_SPEED: float = 5.0;

# https://lospec.com/palette-list/od-10
#const COLOR_BACKGROUND: Color = Color('#2f2e33');
#const COLOR_PLAYER: Color = Color('#f3cb98');
#const COLOR_PLATFORM: Color = Color('#d9ede0');
#const COLOR_PLATFORM_THORNS: Color = COLOR_PLATFORM;
#const COLOR_DEADZONE: Color = Color('#3e527d');

# https://lospec.com/palette-list/japanese-woodblock
const COLOR_BACKGROUND: Color = Color('#243d5c');
const COLOR_PLAYER: Color = Color('#e0c872');
const COLOR_PLATFORM: Color = Color('#b1a58d');
const COLOR_PLATFORM_THORNS: Color = COLOR_PLATFORM;
const COLOR_DEADZONE: Color = Color('#d9ac8b');
