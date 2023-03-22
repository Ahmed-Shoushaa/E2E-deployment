resource "aws_ecr_repository" "ecr-app" {
  name                 = "app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "ecr-db" {
  name                 = "db"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "app-repo-url"{
  value = aws_ecr_repository.ecr-app.repository_url
}

output "db-repo-url"{
  value = aws_ecr_repository.ecr-db.repository_url
}
