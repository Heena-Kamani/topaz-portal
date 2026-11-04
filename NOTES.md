# Notes

Where things stand and what's next.

## Now

Clients, quotes, line items, the client's private link, and accepting all work. Tests pass.

Not deployed yet. The studio side needs a sign-in first.

## Next

1. **Sign-in for the studio side.** Rails 8's built-in authentication generator, one user. The client link (`/q/:token`) stays open.
2. **Optional extras.** Line items the client can tick on or off before accepting. The accepted total only counts what they chose.
3. **Revisions.** A sent quote can still be edited, and the client sees the change. Either warn me, or save a new revision and keep the old one.
4. **Deploy.** Rails 8 with SQLite. Set the real domain so share links point to it.

## Decisions

- Money is stored in cents. Tax is in basis points (500 = 5% GST).
- Accepting stores `accepted_total_cents` as the record of what was agreed.
- The logo and colours aren't final, so the look is neutral for now. Every brand choice (accent colour, font) lives in `app/assets/stylesheets/brand.css`; when the brand is ready, update that, the wordmark in both layouts, and `public/icon.svg`.
- No GraphQL for now. If I add it, it's an API alongside the app, not a replacement.

## Rules for this repo

- It's public: no real client details, no keys, never commit `config/master.key`.
