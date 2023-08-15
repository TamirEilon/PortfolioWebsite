provider "google" {
  credentials = file("${{ secrets.GCP_SA_KEY")
  project     = "myfinalproject2-395806"
  region      = "me-west1"
}

resource "google_container_cluster" "my_cluster" {
  name               = "my-gke-cluster"
  location           = "me-west1"
  initial_node_count = 3

  node_config {
    machine_type = "n1-standard-2"
  }

  // You can add more cluster configuration here
}
