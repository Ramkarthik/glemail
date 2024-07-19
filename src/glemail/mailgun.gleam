import gleam/bit_array
import gleam/http
import gleam/http/request.{type Request}
import gleam/list
import gleam/result
import gleam/string
import glemail/multipart
import glemail/provider.{type Email}

pub fn request(
  email: Email,
  api_key: String,
  domain: String,
) -> Result(Request(String), Nil) {
  let auth =
    string.append("api:", api_key)
    |> bit_array.from_string()
    |> bit_array.base64_encode(False)

  let basic = string.append("Basic ", auth)

  let to =
    result.unwrap(
      list.reduce(email.to, fn(acc, e) {
        string.append(acc, ",")
        |> string.append(e)
      }),
      "",
    )

  let text = case email.body {
    provider.TextBody(text) -> text
    provider.HtmlBody(_, text) -> text
  }

  let html = case email.body {
    provider.TextBody(text) -> text
    provider.HtmlBody(html, _) -> html
  }

  let form_data = [
    #("from", email.from),
    #("to", to),
    #("subject", email.subject),
    #("html", html),
    #("text", text),
  ]

  let req =
    request.new()
    |> request.prepend_header("authorization", basic)
    |> request.set_method(http.Post)
    |> multipart.add(form_data)
    |> request.set_host("api.mailgun.net")
    |> request.set_path("/v3/" <> domain <> "/messages")

  Ok(req)
}
