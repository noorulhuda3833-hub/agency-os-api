# Agency OS – Backend

Agency OS is a client management platform built for digital agencies. It helps users manage workspaces, organize client information, keep track of notes, and generate AI-powered client briefings.

This repository contains the backend API built with Ruby on Rails and PostgreSQL. It connects to the Next.js frontend and handles the application's data, authentication, and business logic.

## Live Demo

* **Frontend:** [Agency OS](https://agency-os-frontend-fab3emsl0-noorulhuda3833-7673s-projects.vercel.app/)
* **Backend API:** [Agency OS API](https://agency-os-api-ma7u.onrender.com/)

## Features

* **Authentication:** User signup, login, and JWT-based authentication.
* **Workspaces:** Create and manage workspaces to organize client information.
* **Client Management:** Add clients, manage their details, and associate them with companies.
* **Notes:** Create, edit, delete, and view client notes. Notes can include different types, such as meetings, calls, emails, and tasks.
* **File Attachments:** Attach files to client notes.
* **Real-Time Updates:** Uses Action Cable and WebSockets to update notes without refreshing the page.
* **AI Client Briefings:** Generates structured client summaries from stored notes using OpenRouter.
* **Briefing History:** Saves generated briefings so users can view them later.

## Tech Stack

* Ruby
* Ruby on Rails (API)
* PostgreSQL
* JWT
* Action Cable and WebSockets
* OpenRouter
* Active Storage
* Minitest
* RuboCop

## How the AI Briefing Works

The AI briefing feature takes a client's saved notes and sends them to an AI model through OpenRouter.

The generated briefing is organized into six sections:

1. Client Summary
2. Key Points
3. Action Items
4. Important Decisions
5. Risks or Concerns
6. Next Steps

The briefing is saved in the database and can be viewed again through the briefing history.

## Project Structure

```text
agency_os_api/
├── app/
│   ├── channels/
│   ├── controllers/
│   ├── models/
│   └── services/
├── config/
├── db/
├── test/
├── Gemfile
├── Gemfile.lock
└── README.md
```

## Getting Started

### Requirements

Make sure you have the following installed:

* Ruby
* Rails
* PostgreSQL
* Bundler

### 1. Clone the repository

```bash
git clone https://github.com/noorulhuda3833-hub/agency-os-api.git
```

### 2. Open the project

```bash
cd agency-os-api
```

### 3. Install dependencies

```bash
bundle install
```

### 4. Configure the database

Update `config/database.yml` with your local PostgreSQL credentials.

Make sure PostgreSQL is running before continuing.

### 5. Configure environment variables

Set the required environment variables for your local setup, including the database connection and any secrets used for authentication and AI integration.

Do not commit passwords, API keys, or other secrets to GitHub.

### 6. Set up the database

```bash
ruby bin/rails db:create
ruby bin/rails db:migrate
```

### 7. Start the server

```bash
ruby bin/rails server
```

The backend will run at:

`http://localhost:3000`

## API Overview

Here are some of the main API endpoints:

| Method | Endpoint                                                          | Description               |
| ------ | ----------------------------------------------------------------- | ------------------------- |
| POST   | `/signup`                                                         | Register a new user       |
| POST   | `/login`                                                          | Log in                    |
| GET    | `/dashboard`                                                      | Get dashboard information |
| GET    | `/workspaces`                                                     | Get the user's workspaces |
| POST   | `/workspaces`                                                     | Create a workspace        |
| GET    | `/companies`                                                      | Get companies             |
| POST   | `/companies`                                                      | Create a company          |
| GET    | `/workspaces/:workspace_id/clients`                               | Get clients               |
| POST   | `/workspaces/:workspace_id/clients`                               | Create a client           |
| GET    | `/workspaces/:workspace_id/clients/:client_id/notes`              | Get client notes          |
| POST   | `/workspaces/:workspace_id/clients/:client_id/notes`              | Create a note             |
| PATCH  | `/workspaces/:workspace_id/clients/:client_id/notes/:id`          | Update a note             |
| DELETE | `/workspaces/:workspace_id/clients/:client_id/notes/:id`          | Delete a note             |
| POST   | `/workspaces/:workspace_id/clients/:client_id/briefing`           | Generate an AI briefing   |
| GET    | `/workspaces/:workspace_id/clients/:client_id/briefing_documents` | Get briefing history      |

For the complete list of routes, run:

```bash
ruby bin/rails routes
```

## Authentication

The API uses JWT for authentication.

After logging in, the frontend sends the token with protected requests using the following header:

```http
Authorization: Bearer YOUR_JWT_TOKEN
```

The backend validates the token before allowing access to protected resources.

## Database Models

The main models used in the application are:

* **User:** Stores user account information.
* **Workspace:** Organizes clients for each user.
* **Company:** Stores company information.
* **Client:** Stores client details.
* **Note:** Stores notes related to clients.
* **BriefingDocument:** Stores generated AI briefings.

## Testing

To run the backend tests:

```bash
ruby bin/rails test
```

To check the code with RuboCop:

```bash
ruby bin/rubocop
```

## Deployment

The project is deployed using:

* **Frontend:** Vercel
* **Backend:** Render
* **Database:** Neon

The backend connects to the hosted PostgreSQL database through its configured database connection.

## Related Repository

* **Frontend Repository:** [Agency OS Frontend](https://github.com/noorulhuda3833-hub/agency-os-frontend)

## Author

**Noor Ul Huda**
Full Stack Developer

[GitHub Profile](https://github.com/noorulhuda3833-hub)
