# ForgeFit — iOS Workout Tracker

ForgeFit is a clean, modern workout-tracking app built for people who want a simple and powerful way to record their training and monitor progress.

I created ForgeFit because many fitness apps feel overly complicated, place important features behind subscriptions, or include distractions that make workout logging slower than it should be.

ForgeFit focuses on:

- Fast workout logging
- Strength progression
- Custom workout templates
- Flexible training splits
- Workout history
- Personal records
- Offline data storage
- Cloud synchronisation
- User-controlled backups and exports
- Interface customisation

---

## Platform

- **Platform:** iOS
- **Framework:** Flutter
- **Storage:** Drift and SQLite
- **Cloud:** Supabase
- **State management:** Riverpod
- **Status:** Active development

---

# Features

## 🏋️ Workout Tracking

ForgeFit provides a practical workout-logging experience designed for use inside the gym.

Record:

- Exercises
- Sets
- Repetitions
- Weight
- Working-set status
- Exercise notes
- Previous performance
- Workout volume

During an active workout, you can:

- View your previous performance
- Mark individual sets as complete
- Uncomplete sets when corrections are needed
- Complete all valid sets for an exercise
- Uncomplete all sets
- Add additional sets
- Add exercises during the workout
- Reorder exercises and sets
- Finish and save the completed session

The interface is designed to minimise the amount of time spent using your phone while training.

---

## 📊 Progress Tracking

ForgeFit allows you to follow your strength progress for individual exercises.

You can:

- Select an exercise from your workout history
- View your best completed weight over time
- See progress displayed on a line chart
- Compare your starting and latest weight
- View the total weight change
- View the percentage improvement
- Review personal-record information

Available time ranges include:

- 1 week
- 1 month
- 3 months
- 6 months
- 1 year
- All time

Example:

> **Exercise:** Lat Pulldown  
> **Starting weight:** 45 kg  
> **Latest weight:** 55 kg  
> **Total progress:** +10 kg

Only completed workouts and valid completed sets are included in progress calculations.

---

## 🏆 Personal Records

ForgeFit identifies useful exercise records from completed training data.

Records can include:

- Heaviest completed weight
- Highest completed repetition count
- Best completed set
- Estimated one-repetition maximum
- Best workout volume
- Date each record was achieved

Personal records are calculated from real workout history rather than manually entered values.

---

## 📈 Workout Statistics

ForgeFit provides useful training statistics, including:

- Workouts completed
- Completed sets
- Completed repetitions
- Training volume
- Today’s workout count
- All-time workout count
- Recent workouts
- Frequently performed exercises
- Workout consistency
- Progress across selected time ranges

Statistics automatically refresh when workout information changes.

---

## 📅 Workout History

Completed sessions are stored in a searchable workout-history list.

Each workout can display information such as:

- Workout name
- Date and time
- Duration
- Exercise count
- Working-set count
- Total volume
- Personal records achieved

You can search completed workouts and open individual sessions to review their details.

---

## 🗓️ Workout History Calendar

ForgeFit also provides a calendar view for browsing previous training.

You can:

- Navigate between months
- See which days contain completed workouts
- Select a calendar date
- View every workout completed on that day
- Open individual workout records
- Review training consistency across weeks and months

Workout dates are handled using the user’s local calendar day.

---

## 📚 Workout Templates

Create and organise your own workout routines.

ForgeFit supports:

- Unlimited custom templates
- Multiple workout splits
- Templates without a split
- Upper-body routines
- Lower-body routines
- Full-body routines
- Custom training structures
- Template duplication
- Template editing
- Template deletion
- Exercise ordering
- Set ordering
- Multi-exercise selection

ForgeFit does not force users into a particular workout program or split.

---

## 🗂️ Custom Workout Splits

Organise templates using flexible training splits.

You can:

- Create custom splits
- Rename splits
- Reorder splits
- Duplicate splits
- Delete splits
- Assign templates to splits
- View all templates together
- View templates without an assigned split

This allows ForgeFit to support many different training styles.

---

## 🔎 Exercise Library

Forge
