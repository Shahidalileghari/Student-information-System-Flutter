# Student Information System — Flutter

A modular Flutter application for managing student records and core academic workflows.

## Features
- Dashboard and responsive Material 3 UI; system-aware light/dark themes
- Student CRUD, search, duplicate roll-number protection and form validation
- Course catalogue with unique course codes and credit-hour validation
- Student-course enrollment by academic term; duplicate enrollment protection
- Attendance tracking (present, absent, late), one record per enrollment/date
- Assessment grade entry with score-range validation and percentage calculation
- SQLite persistence with foreign keys, unique constraints and cascading deletes
- Provider state management and repository abstraction
- Unit/widget tests, lint configuration, architecture docs and GitHub Actions CI

## Stack
Flutter, Dart 3, Provider, SQLite (`sqflite`), UUID.

## Run
Install Flutter, then:
```bash
flutter doctor
flutter pub get
dart format .
flutter analyze
flutter test
flutter run
```
SQLite adapter targets supported mobile/desktop platforms. For Flutter Web, replace the SQLite adapter with IndexedDB or a remote API implementation.

## Structure
```text
lib/
  app/                 App root and theme
  domain/models/       Student, Course, Enrollment, Attendance, Grade
  domain/repositories/ Repository contract
  data/database/       SQLite schema and initialization
  data/repositories/   SQLite repository
  features/            Dashboard and academic modules
  shared/              Reusable UI components
test/                  Unit and widget tests
docs/                  Architecture, user guide, testing, roadmap
```

## Architecture
Presentation → Provider controller → repository contract → SQLite implementation. Domain models do not depend on Flutter widgets or database APIs. Replace the repository implementation to connect a REST backend without redesigning the screens.

## Important production considerations
This is a local-first professional starter, not a complete multi-user institutional deployment. Before using real student records, add authenticated backend APIs, role-based access control, audit logs, encrypted transport/storage, backup/restore, privacy and retention policies, and server-side validation. Never commit real student data or secrets.
