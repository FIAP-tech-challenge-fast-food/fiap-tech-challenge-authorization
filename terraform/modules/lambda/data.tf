data "aws_iam_role" "labrole" {
  name = "LabRole"
}

data "archive_file" "tech_challenge_lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../../../artifact/fastfood.lambda-0.0.1-SNAPSHOT-jar-with-dependencies.jar"
  output_path = "${path.module}/../../../artifact/fastfood_lambda.zip"
}