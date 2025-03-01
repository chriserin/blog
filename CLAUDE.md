# Blog Project - Agent Assistant Guide

## Common Commands
- Build: `mix deps.get && mix compile`
- Start dev server: `mix phx.server`
- Test all: `mix test`
- Test single file: `mix test path/to/test.exs`
- Test single test: `mix test path/to/test.exs:line_number`
- Format code: `mix format`
- Deploy assets: `mix assets.deploy`
- Database setup: `mix ecto.setup`

## Code Style Guidelines
- Use 2-space indentation
- Include @moduledoc and @doc documentation
- Chain functions with pipe operator (|>)
- Prefer pattern matching in function heads over conditionals
- Group related functions together
- For GenServers: separate public API from server callbacks
- Use @impl true for callback implementations
- Follow Phoenix HEEX template conventions:
  - Use `{}` curly braces for code in HTML attributes (e.g. `<a href={path()}>Link</a>`)
  - Use `<%= %>` for code in tag content (e.g. `<div><%= value %></div>`)
- Use consistent naming: snake_case for functions/variables, PascalCase for modules
- Wrap long lines at 98 characters
- Use Elixir's Result tuple pattern with {:ok, result} | {:error, reason}
- Use Phoenix.VerifiedRoutes.url for generating full URLs with hostname

## Project Structure
- Phoenix-based blog application with TIL (Today I Learned) feature
- Uses Phoenix LiveView for interactive components
- Files stored in private TILs directory