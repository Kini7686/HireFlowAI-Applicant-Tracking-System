# HireFlow AI

AI-powered Applicant Tracking System built with **Ruby on Rails 7.1**, demonstrating production-style Rails architecture: Hotwire, Sidekiq, service objects, Pundit authorization, and Active Storage.

## Features

- **Role-based access** — Admin, Recruiter, Candidate (Devise + Pundit)
- **Job management** — CRUD with draft/published/closed statuses
- **Resume upload** — PDF via Active Storage with async parsing (Sidekiq)
- **ATS scoring** — Keyword-based scoring service with optional OpenAI feedback
- **Application pipeline** — Kanban-style board with drag-and-drop (Stimulus)
- **Real-time UI** — Turbo Frames/Streams + Action Cable notifications
- **Admin dashboard** — System-wide metrics via query objects

## Tech Stack

| Layer | Technology |
|-------|------------|
| Framework | Ruby on Rails 7.1 |
| Database | PostgreSQL |
| Queue | Redis + Sidekiq |
| Frontend | Hotwire (Turbo + Stimulus) + Tailwind CSS |
| Auth | Devise |
| Authorization | Pundit |
| Storage | Active Storage (local or S3-compatible) |
| Testing | RSpec, FactoryBot, Shoulda |

## Screenshots

> _Add screenshots of landing page, recruiter pipeline, and admin dashboard here._

## Quick Start (Docker — recommended)

**Prerequisites:** [Docker Desktop](https://www.docker.com/products/docker-desktop/) only. No local Ruby required.

1. **Start Docker Desktop**

2. **Clone and configure**
   ```bash
   cd "Ruby on Rail"
   cp .env.example .env
   ```

3. **Build and run**
   ```bash
   docker compose up --build
   ```

4. **Seed database** (first time, in another terminal)
   ```bash
   docker compose exec web rails db:seed
   ```

5. **Open** [http://localhost:3000](http://localhost:3000)

### Seed accounts

| Role | Email | Password |
|------|-------|----------|
| Admin | admin@hireflow.ai | password123 |
| Recruiter | recruiter@hireflow.ai | password123 |
| Candidate | candidate@hireflow.ai | password123 |

## Environment Variables

See [`.env.example`](.env.example). All paid services are **optional**:

| Variable | Required | Description |
|----------|----------|-------------|
| `DATABASE_*` | Yes (Docker sets defaults) | PostgreSQL connection |
| `REDIS_URL` | Yes | Sidekiq + Action Cable |
| `SECRET_KEY_BASE` | Yes | Rails secret |
| `ACTIVE_STORAGE_SERVICE` | No | `local` (default, free) or `amazon` |
| `OPENAI_API_KEY` | No | Enhanced AI feedback; fallback works without it |
| `AWS_*` | No | Only if using S3 storage |

## Sidekiq

- Worker runs in the `sidekiq` Docker service automatically.
- **Web UI:** [http://localhost:3000/sidekiq](http://localhost:3000/sidekiq) (admin login required)
- Jobs: `ResumeParsingJob`, `AtsScoringJob`, `NotificationJob`

## Running Tests

```bash
docker compose exec web bundle exec rspec
```

## Project Structure

```
app/
  controllers/    # Thin controllers
  models/         # Business rules, enums, callbacks
  services/       # ATS scoring, resume parsing, OpenAI
  jobs/           # Sidekiq background jobs
  policies/       # Pundit authorization
  views/          # Server-rendered Hotwire UI
  javascript/     # Stimulus controllers
  queries/        # Dashboard stats
```

## Architecture Highlights

- **Service objects** — `AtsScoringService`, `ResumeTextExtractor`, `OpenAiFeedbackService`
- **Background jobs** — Resume parsing and ATS scoring decoupled from HTTP requests
- **Turbo Streams** — Live notification and application status updates
- **Policies** — `JobApplicationPolicy`, `JobPolicy` for role-based access

## Future Improvements

- [ ] Semantic similarity via embeddings (OpenAI or local model)
- [ ] Email notifications (Action Mailer + SendGrid)
- [ ] Interview scheduling module
- [ ] Multi-tenant organizations
- [ ] CI/CD pipeline and production deployment guide
- [ ] Full system test suite with Capybara

## License

MIT — for portfolio and learning use.
