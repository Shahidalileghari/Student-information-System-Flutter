# Architecture
- Presentation: feature pages and reusable widgets.
- Application: Provider `ChangeNotifier` controller.
- Domain: immutable entities and repository contract.
- Data: SQLite schema and repository adapter.

UUIDs provide stable identifiers. SQLite foreign keys and unique constraints protect relationships. For multi-user deployments, implement a secured backend and remote repository.

## Production checklist
- [ ] Authentication and roles (administrator, faculty, student)
- [ ] Remote API, server-side authorization and validation
- [ ] Audit events for grade, attendance and profile changes
- [ ] Encryption, backup/restore, retention and privacy controls
- [ ] Integration and end-to-end tests on supported devices
