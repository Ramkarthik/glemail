import gleam/http/request.{type Request}
import gleam/int
import gleam/list
import gleam/string

pub fn add(
  request: Request(String),
  body: List(#(String, String)),
) -> Request(String) {
  let boundary_key = int.to_string(int.random(10_000_000))
  let boundary = string.append("--", boundary_key)

  let content =
    list.fold(body, "", fn(a, b) {
      string.append(a, add_formdata_param(b.0, b.1, boundary))
    })

  let body =
    string.append("\r\n", boundary)
    |> string.append(content)
    |> string.append("\r\n")

  let request =
    request
    |> request.prepend_header(
      "content-type",
      string.append("multipart/form-data; boundary=", boundary_key),
    )
    |> request.prepend_header(
      "content-length",
      int.to_string(string.length(body)),
    )
    |> request.set_body(body)

  request
}

fn add_formdata_param(key: String, val: String, boundary: String) -> String {
  let clrf = "\r\n"
  let content_disposition = "Content-Disposition: form-data; name=\"$$key$$\""

  string.append(clrf, string.replace(content_disposition, "$$key$$", key))
  |> string.append(clrf)
  |> string.append(clrf)
  |> string.append(val)
  |> string.append(clrf)
  |> string.append(boundary)
}
