output "api_key" {
  sensitive = true
  value     = google_apikeys_key.google_maps_api_key.key_string
}
