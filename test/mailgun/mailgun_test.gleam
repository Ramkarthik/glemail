import gleam/result
import gleeunit/should
import glemail
import glemail/provider

pub fn mailgun_test() {
  let req =
    provider.Email(
      from: "from@test.com",
      to: ["to@test.com"],
      subject: "This is a test subject",
      body: provider.TextBody("This is a test body"),
    )
    |> provider.MailGun(api_key: "API_KEY", domain: "DOMAIN")
    |> glemail.request()

  result.then(req, fn(r) {
    r.host
    |> should.equal("api.mailgun.net")

    r.path
    |> should.equal("/v3/DOMAIN/messages")

    Ok(Nil)
  })
}
