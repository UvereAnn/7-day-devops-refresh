resource "google_project_service" "artifactregistry" {
  project            = var.project_id
  service            = "artifactregistry.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "run" {
  project            = var.project_id
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

resource "google_artifact_registry_repository" "app" {
  project       = var.project_id
  location      = var.region
  repository_id = "day5-app"
  description   = "Day 5 application container images"
  format        = "DOCKER"
  depends_on    = [google_project_service.artifactregistry]
}

resource "google_cloud_run_v2_service" "app" {
  project  = var.project_id
  name     = "devops-cicd-lab"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"
  template {
    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.app.repository_id}/devops-cicd-lab:${var.image_tag}"
      ports { container_port = 8080 }
    }
  }
  depends_on = [google_project_service.run]
}
