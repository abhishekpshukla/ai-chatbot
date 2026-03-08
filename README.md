# AI Customer Support Chatbot

**Production-ready embeddable chatbot built with Ruby on Rails 8.1.2 + OpenAI GPT-4o-mini**

[![Live Demo](https://img.shields.io/badge/demo-live-brightgreen?style=for-the-badge)](https://ai-chatbot-production-d6ce.up.railway.app/)
[![CI](https://github.com/abhishekpshukla/ai-chatbot/actions/workflows/ci.yml/badge.svg)](https://github.com/abhishekpshukla/ai-chatbot/actions/workflows/ci.yml)

---

## Features

- **AI-powered conversations** — GPT-4o-mini for fast, cost-effective customer support replies
- **Business-specific personas** — Each business has its own system prompt (tone, policies, FAQ)
- **Conversation history** — Sessions and messages stored in PostgreSQL; last 10 messages sent as context to the model
- **Modern chat UI** — Tailwind CSS widget with message bubbles, typing indicator, and smooth scrolling
- **Session-based threading** — One conversation per browser session per business; no login required for demo
- **Production hardening** — HTTP Basic Authentication (optional) to protect the demo; JSON error handling so the UI never breaks on API failures
- **Docker-first dev** — PostgreSQL 16 + Rails + Tailwind watcher in one `docker compose up`; no local Ruby/Node required
- **Rails 8 stack** — Solid Cache/Queue/Cable, Propshaft, Hotwire (Turbo + Stimulus), Kamal-ready

---

## Tech Stack

| Layer        | Technology |
|-------------|------------|
| **Framework** | Ruby on Rails 8.1.2 |
| **Language**  | Ruby 3.4.1 |
| **Database**  | PostgreSQL 16 |
| **AI**        | OpenAI API (GPT-4o-mini) via [ruby-openai](https://github.com/alexrudall/ruby-openai) |
| **Frontend**  | Tailwind CSS, Hotwire (Turbo + Stimulus), importmaps |
| **Assets**    | Propshaft, Tailwind CSS |
| **Dev**       | Docker & Docker Compose, Foreman (Rails + Tailwind watch) |
| **Deploy**    | Kamal-ready, Thruster, Railway-compatible |

---

## Quick Start

**Prerequisites:** Docker and Docker Compose.

```bash
# Clone and enter the project
cd ai_chatbot

# Start PostgreSQL and the Rails app (with Tailwind watcher)
docker compose up -d

# Create the database and run migrations
docker compose exec web bin/rails db:create db:migrate

# Seed the demo business (optional)
docker compose exec web bin/rails db:seed
```

Open **http://localhost:3000** in your browser.

**Required:** Set `OPENAI_API_KEY` in a `.env` file (see [Configuration](#️-configuration)) so the chat can call the OpenAI API.

---

## Tests

Run the RSpec test suite:

```bash
docker compose run --rm web bundle exec rspec
```

Use the test database by setting the environment:

```bash
docker compose run --rm -e RAILS_ENV=test -e DATABASE_URL=postgres://postgres:postgres@postgres:5432/ai_chatbot_test web bundle exec rspec
```

---

## Configuration

Use a `.env` file in the project root (or set these in your host/deployment environment). Docker Compose loads `.env` for the web service.

| Variable | Required | Description |
|----------|----------|-------------|
| `OPENAI_API_KEY` | Yes | Your [OpenAI API key](https://platform.openai.com/api-keys) for GPT-4o-mini |
| `DEMO_USERNAME`  | Production only | HTTP Basic Auth username (e.g. for demo site) |
| `DEMO_PASSWORD`  | Production only | HTTP Basic Auth password |

Example `.env`:

```env
OPENAI_API_KEY=sk-your-key-here
DEMO_USERNAME=demo
DEMO_PASSWORD=your-secure-password
```

---

## Use Cases

- **Customer support** — Answer product and order questions 24/7 with a consistent tone and policies
- **FAQ bots** — Train the system prompt on your docs; reduce tickets and wait times
- **Lead qualification** — Collect context and hand off to sales when needed
- **Internal help desks** — Onboard employees or answer policy/IT questions
- **Embeddable widget** — Use the chat UI as a starting point to embed on marketing or help-center pages

---

## 📸 Screenshots

<!-- Add a screenshot of the chat UI here, e.g.:
![Chat UI](docs/screenshot.png)
-->

![Chat UI](docs/screenshot.png)


---

## Contact

Feel free to reach out:

- **Email:** abhishekpshukla@gmail.com
- **GitHub:** https://github.com/abhishekpshukla
- **LinkedIn:** https://www.linkedin.com/in/abhishekshukla/
---

## License

This project is licensed under the MIT License.
