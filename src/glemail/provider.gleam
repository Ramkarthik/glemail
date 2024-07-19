pub type EmailProvider {
  MailGun(email: Email, api_key: String, domain: String)
}

pub type Email {
  Email(from: String, to: List(String), subject: String, body: EmailBody)
}

pub type EmailBody {
  TextBody(text: String)
  HtmlBody(html: String, text: String)
}
