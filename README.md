# Gleam Email (Glemail)

A lightweight client wrapper for various email providers.

### Why

Switching email providers is not easy. You have to read the API reference or download the specific SDK. Either way, you have to both understand how the new API works and do a lot of code changes.

With Glemail, you set up once and switching provider is as easy as invoking the required provider (`enum EmailProvider`). Glemail also makes it easy to have fallback email providers for your system without introducing a lot of code.

### Supported providers

- MailGun
- SendGrid (coming soon)
- Postmark (coming soon)
- Resend (coming soon)

...and more

### Usage

It's still very easy for usage. It currently works for MailGun. You would set it up like below:

```gleam
import glemail
import glemail/provider
import gleam/hackney


// Set up email, choose provider, create request
let req =
    provider.Email(
      from: "from@test.com",
      to: ["to@test.com"],
      subject: "This is a test subject",
      body: provider.TextBody("This is a test body"),
    )
    |> provider.MailGun(api_key: "API_KEY", domain: "DOMAIN")
    |> glemail.request()

// Send the request using hackney or any email client of your choice
let assert Ok(response) = hackney.send(request)

```