#Integrate API gateway with Hello lambda
resource "aws_apigatewayv2_integration" "lambda_hello" {
    api_id = aws_apigatewayv2_api.main.id

    integration_uri = aws_lambda_function.hello.invoke_arn  #(Hello Lambda file link)
    integration_type = "AWS_PROXY"  #(to forward request from API gateway)
    integration_method = "POST"     #(to Lambda)
}

#Specify the routes to pass from Lambda
resource "aws_apigatewayv2_route" "get-hello" {
    api_id = aws_apigatewayv2_api.main.id
    route_key = "GET /hello"
    target = "integrations/${aws_apigatewayv2_integration.lambda_hello.id}"
}

resource "aws_apigatewayv2_route" "post-hello" {
    api_id = aws_apigatewayv2_api.main.id
    route_key = "POST /hello"
    target = "integrations/${aws_apigatewayv2_integration.lambda_hello.id}"
}

#Add permissions to API gateway to invoke Lambda function
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}

output "hello_base_url" {
  value = aws_apigatewayv2_stage.dev.invoke_url
}