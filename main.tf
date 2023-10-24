provider "aws" {
  region = "eu-central-1"
  profile = "student"
}

resource "aws_sqs_queue" "my_queue" {
  name = "my-queue"
}

resource "aws_sqs_queue_policy" "my_queue_policy" {
  queue_url = aws_sqs_queue.my_queue.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "AllowLambda",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:*",
      "Resource": "${aws_sqs_queue.my_queue.arn}"
    }
  ]
}
POLICY
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "my-lambda"

  role          = aws_iam_role.lambda_exec.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"

  filename      = "lambda_function_payload.zip"
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_sqs_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

resource "aws_lambda_event_source_mapping" "sqs_lambda_trigger" {
  event_source_arn = aws_sqs_queue.my_queue.arn
  function_name    = aws_lambda_function.my_lambda.arn
  batch_size       = 5
}


output "queue_url" {
  value = aws_sqs_queue.my_queue.id
}
