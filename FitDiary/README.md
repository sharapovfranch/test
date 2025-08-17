# FitDiary (iOS 17+, SwiftUI)

A simple, fully local fitness diary with Nutrition (Chat + History) and Workouts. No external services; data is stored as a single JSON file in the app's Documents directory.

## Requirements
- Xcode 15+
- iOS 17+ (simulator or device)

## Run
1. Open `FitDiary.xcodeproj` in Xcode.
2. Select an iOS 17 simulator (or your iPhone) and press Run.
3. First launch will create the data file (`fitdiary.json`) in Documents. In Debug builds, a small seed is written if the file is absent.

## Features
- Overview: set Daily calories/protein; see monthly day progress with green donut (avg of kcal+protein completion); set Weekly workouts goal and see 12-week ribbon with ✓/✗.
- Nutrition:
  - Chat: enter text like "Oatmeal 300g, banana" and tap Send. A local parser suggests a meal; tap "Add to history" to save.
  - History: monthly day ribbon + grouped meals by day. Icons reflect time of day. Rows show title · kcal and P/F/C with time.
- Workouts: 12-week ribbon with ✓/✗ vs goal; grouped list of workouts by day. Tap Add to create a workout with default 5 sets, add more as needed, select effort, and Save.

## Editing goals and adding entries
- Overview tab: edit goals and Save buttons to persist.
- Nutrition > Chat: use free text, e.g. "oatmeal 300g".
- Workouts: use the Add button in the navigation bar.

## Data persistence
- Stored in `Documents/fitdiary.json`. To reset, delete the file from the app's Documents (e.g., via the Xcode Devices window) and relaunch.

## Seed data (Debug)
- On first launch in Debug builds, 1–2 meals for today and yesterday, and 1–2 workouts for current/previous week are seeded if the JSON does not exist.

## TODO
- Replace the simple heuristic in `FoodChatView.suggest(from:)` with a real LLM call.
- Add photo attachments for meals.