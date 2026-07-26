# ForgeFit — iOS Workout Tracker

ForgeFit is a modern iOS workout tracker built for fast gym logging, flexible workout planning, progress tracking, and control over your training data.

The app uses a local-first system, allowing workouts to remain available offline while supporting optional Supabase cloud synchronisation.

---

## Main Features

### Workout Logging

- Record exercises, sets, reps, weight, and notes
- View previous performance while training
- Complete or uncomplete individual sets
- Complete or uncomplete all sets for an exercise
- Add exercises and additional sets during a workout
- Finish, save, review, edit, or delete workouts
- No unnecessary workout timer

### Workout Templates and Splits

- Create unlimited workout templates
- Create custom training splits
- Use templates without assigning a split
- Add multiple exercises at once
- Reorder exercises and sets
- Edit, duplicate, move, and delete templates
- Duplicate splits with their templates and exercises

### Exercise Library

- Built-in exercise catalogue
- Search by exercise name
- Filter by muscle group or equipment
- Recent and favourite exercises
- Create and edit custom exercises
- Support for equipment such as barbells, dumbbells, cables, machines, resistance bands, kettlebells, bodyweight, cardio equipment, and more

### Progress Tracking

- Select any exercise from workout history
- View weight progress on a line chart
- Each chart point shows the highest completed weight for that date
- Compare starting weight, latest weight, and total change
- View progress across:
  - 1 week
  - 1 month
  - 3 months
  - 6 months
  - 1 year
  - All time
- Personal records and workout statistics
- Training volume and workout consistency information

### Home and History

- Home workout calendar
- History calendar with completed workout indicators
- View workouts completed on a selected date
- Recent workout summaries
- Workout, set, repetition, and volume statistics
- Open previous workouts for detailed review

### Data and Synchronisation

- Local Drift/SQLite database
- Supabase account and cloud synchronisation
- Manual **Sync Now** action
- JSON backup export
- Transactional JSON restore
- Workout-history CSV export
- Stable IDs and relationships preserved during backup and restore

### Customisation

- Dark interface designed for gym use
- Select any accent colour
- Accent colour updates the app immediately
- Colour selection remains after restarting
- Reset to the default accent
- Optional haptic feedback
- Weight-unit settings

---

## Technology

- **Flutter and Dart** — application interface and logic
- **Drift and SQLite** — local offline database
- **Supabase** — authentication and cloud synchronisation
- **Riverpod** — state management
- **GitHub Actions** — automated unsigned iOS IPA builds

---

## Screenshots

### ForgeFit Showcase

<!-- Place the main promotional image before the nine individual screenshots. -->

<p align="center">
  <img
    src="C503F7C5-4B9B-4087-AD2D-FA8CB2CD8608.png"
    width="900"
    alt="ForgeFit iOS workout tracker showcase"
  >
</p>

<br>

### App Screens

<p align="center">
  <img
    src="E562000B-E703-4575-97BA-78A337272580.png"
    width="240"
    alt="ForgeFit home dashboard"
  >
  <img
    src="BC19E327-495C-45CF-A2C4-ECE9B8998022.png"
    width="240"
    alt="ForgeFit workout templates"
  >
  <img
    src="FBA14493-B5C3-4C2E-8809-71233528E82B.png"
    width="240"
    alt="ForgeFit active workout"
  >
</p>

<p align="center">
  <img
    src="2307CFF2-C19E-46B9-8476-0C833DD1CAB5.png"
    width="240"
    alt="ForgeFit workout history"
  >
  <img
    src="6A7EC3E5-5CCC-48F5-9488-9BF9618D301B.png"
    width="240"
    alt="ForgeFit workout history calendar"
  >
  <img
    src="60E7F89D-8E0E-4309-8567-4436A138974B.png"
    width="240"
    alt="ForgeFit exercise weight progress chart"
  >
</p>

<p align="center">
  <img
    src="9B28E537-20BD-4975-AD06-F252D2585B52.png"
    width="240"
    alt="ForgeFit exercise library"
  >
  <img
    src="1DAC8376-244E-41E2-8E08-A80D830FF236.png"
    width="240"
    alt="ForgeFit recent workouts"
  >
  <img
    src="FF4DBE25-9722-4439-A47F-76B2B3D7558E.png"
    width="240"
    alt="ForgeFit settings and data management"
  >
</p>

---

## Project Status

ForgeFit is an actively developed personal project currently focused on iOS. It is built for practical workout tracking, flexible programming, offline reliability, progress visibility, and user-controlled data.