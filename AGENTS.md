# AGENTS.md

## Build/Lint/Test Commands
- No build system - WoW addon loads in-game
- Manual testing: `/csetupchat` to trigger setup
- Error handling via SafeCall() wrapper

## Code Style Guidelines
- **Lua**: Use local variables, constants in UPPER_CASE
- **Naming**: snake_case for functions, UPPER_CASE for constants
- **Error Handling**: Always use SafeCall() for API calls
- **Imports**: No external dependencies, use _G for global access
- **Formatting**: 4-space indentation, clear comments for complex logic
- **Types**: Dynamic typing, validate with if/nil checks
- **API**: Use FCF_* functions for chat frame manipulation
- **Events**: Register on PLAYER_LOGIN with 2s delay for chat loading