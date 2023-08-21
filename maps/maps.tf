#geocoding and places only for now
resource "google_apikeys_key" "google_maps_api_key" {
  display_name = "Google Maps Geocoding Api Key"
  project      = var.gcp_project_id
  name         = var.maps_api_key_name
  restrictions {
    api_targets {
      service = "geocoding-backend.googleapis.com"
    }
    api_targets {
      service = "places-backend.googleapis.com"
    }
  }
}
