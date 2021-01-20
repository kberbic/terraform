terraform {
  backend "s3" {
    # Replace this with your bucket name!
    encrypt = true
    bucket = "argo-workflow-team-eks"
    region = "us-west-2"
    key = "tyrion-workflow-eks/tyrion-workflow-eks.tfstate"
  }
}
