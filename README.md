# Topaz Portal

The client portal for my design studio, Topaz Design Co.

Quotes usually go out as PDFs, and then there's the back-and-forth of finding out whether the client is happy with them. Here, each quote gets a private link instead. The client opens it, sees every line and the total with GST, and types their name to accept. Once they accept, that version is locked, so neither of us can change it afterwards by accident.

It's also how I'm learning Ruby on Rails, so I'm keeping it small and adding one real piece at a time.

## What it does today

- Add a client and start a quote for them
- Build the quote line by line; subtotal, GST and total work themselves out
- Mark it as sent, which turns on the client's private link
- The client accepts by typing their name; the app records who, when and the exact total they saw
- Accepted quotes can't be edited or deleted

## What's next

- [ ] Sign-in for the studio side (before this goes anywhere public)
- [ ] Optional extras the client can tick on or off before accepting
- [ ] A revision when I change a quote that's already been sent
- [ ] Deploy to topazdesign.dev
- [ ] Project status page for accepted work
- [ ] Invoices from accepted quotes

## How it's built

Rails 8 with SQLite and plain CSS, no front-end framework.

- `app/models/quote.rb` holds the rules: totals, tax, and the lock after acceptance
- Money is stored in whole cents so the math never drifts
- `SharedQuotesController` is the client's side. There's no login there: the link has a long random token, and draft quotes never show up
- `QuotesController`, `LineItemsController` and `ClientsController` are my side

## Run it locally

You need Ruby 3.3 or newer.

```bash
bundle install
bin/rails db:setup   # creates the database and adds made-up sample clients
bin/rails server
```

Then open http://localhost:3000.

## Tests

```bash
bin/rails test
```

They cover the money math, the lock after acceptance, and both sides of the flow: me building and sending a quote, and a client opening their link and accepting it.

The sample data is all made up. Real client details never go in this repo.
