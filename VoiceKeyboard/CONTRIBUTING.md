# Contributing to VoiceKeyboard

Thank you for your interest in contributing to this project!

## Development Setup

1. Clone the repository
2. Open `VoiceKeyboard.xcodeproj` in Xcode 15+
3. Select a development team in signing settings
4. Build and run on simulator or device

## Code Style

We follow the [Google Swift Style Guide](https://google.github.io/swift/):

- 2-space indentation
- Use `let` by default, `var` only when needed
- Descriptive variable names
- Comment complex logic

## Commit Messages

Format: `[TYPE] Brief description`

- `[FEATURE]` New functionality
- `[FIX]` Bug fixes
- `[DOCS]` Documentation updates
- `[REFACTOR]` Code restructuring
- `[TEST]` Test additions

Example: `[FEATURE] Add waveform visualization during recording`

## Pull Request Process

1. Create a feature branch: `git checkout -b feature/description`
2. Make changes following code style
3. Test on both iPhone and iPad
4. Push and create pull request
5. Include description of changes and testing performed

## Testing Requirements

Before submitting PR, verify:
- [ ] Code compiles without warnings
- [ ] Feature works on iPhone simulator
- [ ] Feature works on iPad simulator
- [ ] Dark mode appearance correct
- [ ] Error cases handled
- [ ] No memory leaks (Xcode Instruments)

---

Happy coding!
