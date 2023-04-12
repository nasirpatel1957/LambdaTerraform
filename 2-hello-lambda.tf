#Creating IAM role for Lambda (IAM Trust policy.json)
resource "aws_iam_role" "hello_lambda_exec" {
  name = "hello-lambda"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

#Attaching policies to the role (LambdaBasicExecutionRole)
resource "aws_iam_role_policy_attachment" "hello_lambda_policy" {
    role = aws_iam_role.hello_lambda_exec.id
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

#Creating Lambda function
resource "aws_lambda_function" "hello" {
    function_name = "hello"

    s3_bucket = aws_s3_bucket.lambda_bucket.id
    s3_key = aws_s3_object.lambda_hello.key

    runtime = "nodejs16.x"
    handler = "function.handler"  #(same as javascript filename)

    #(source code is needed to redeploy the function if anything is changed)
    source_code_hash = data.archive_file.lambda_hello.output_base64sha256 

    role = aws_iam_role.hello_lambda_exec.arn
}

#Creating Cloudwatch log group (To store the logs)
resource "aws_cloudwatch_log_group" "hello" {
    name = "/aws/lambda/${aws_lambda_function.hello.function_name}"

    retention_in_days = 14

}

#Producing the zip file
data "archive_file" "lambda_hello" {
    type = "zip"

    source_dir = "../${path.module}/hello"
    output_path = "../${path.module}/hello.zip"
}
 
#Uploading the zip archive to S3
resource "aws_s3_object" "lambda_hello" {
    bucket = aws_s3_bucket.lambda_bucket.id

    key = "hello.zip"
    source = data.archive_file.lambda_hello.output_path

    etag = filemd5(data.archive_file.lambda_hello.output_path)
    #(This triggers when the value changes, if obj>16MB, it wont work)
}
