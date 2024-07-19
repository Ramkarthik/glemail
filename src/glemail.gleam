import gleam/http/request.{type Request}
import glemail/mailgun
import glemail/provider.{type EmailProvider}

pub fn request(email_provider: EmailProvider) -> Result(Request(String), Nil) {
  case email_provider {
    provider.MailGun(email, api_key, domain) ->
      mailgun.request(email, api_key, domain)
  }
}
